#!/usr/bin/env python
# coding: utf-8
import geopandas as gpd
import requests
import osm2geojson
import pybdshadow
import pandas as pd
import numpy as np

from firebase_functions import https_fn
from firebase_admin import initialize_app

initialize_app()

@https_fn.on_request()
def calcParkShading(req: https_fn.Request) -> https_fn.Response:
    """Take the coordinate and datetime values passed to this parameter and return a list of the top 3 sunniest parks within  a box of approx 1km by 1km"""
    # Grab the text parameter.
    lat = float(req.args.get("lat"))
    long = float(req.args.get("long"))
    if lat is None or long is None:
        return https_fn.Response("One or more coordinate parameters are missing", status=400)
        
    date = str(req.args.get("dateStr"))
    time = str(req.args.get("timeStr"))
    if date is None or time is None:
        return https_fn.Response("One or more datetime parameters are missing", status=400)

    south, west, north, east = (lat - 0.0045), (long - 0.0045), (lat + 0.0045), (long + 0.0045)
    
    # fetch all ways and nodes
    overpass_url = "http://overpass-api.de/api/interpreter"
    query = f"""
        [out:json];
        (
        way({south}, {west}, {north}, {east}) ["leisure"="park"];
        way({south}, {west}, {north}, {east}) ["building"];
        );
        (._;>;);
        out geom;
        """
    
    response = requests.get(overpass_url, params={'data': query})
    if response.status_code == 200:
        # convert result to GeoDataFrame
        data = response.json()
        geojson = osm2geojson.json2geojson(data)
        geojsonDF = gpd.GeoDataFrame.from_features(geojson)
    else:
        return https_fn.Response("Something went wrong with the overpass api request", status=400)
    
    temp = geojsonDF.tags.apply(pd.Series)

    if 'building:levels' not in temp.columns:
        temp['building:levels'] = np.nan
    
    levels = temp['building:levels'].fillna(1)

    if 'height' in temp.columns:
        approx_ht = temp.height.fillna(round(levels.astype(int) * 128/36))
    else:
        approx_ht = round(levels.astype(int) * 128/36)

    geojsonDF['height'] = approx_ht.astype(int)
    geojsonDF['leisure'] = temp.leisure
    geojsonDF.loc[geojsonDF['leisure'] == 'park', 'height'] = 0
    parks = geojsonDF.loc[geojsonDF['leisure'] == 'park']
    mass = geojsonDF.loc[geojsonDF['leisure'] != 'park']
    
    buildings = pybdshadow.bd_preprocess(mass)
    
    #Given UTC time
    date = pd.to_datetime(f'{date} {time}')\
        .tz_localize('Europe/London')\
        .tz_convert('UTC')
    
    #Calculate shadows
    shadows = pybdshadow.bdshadow_sunlight(buildings,date,roof=True,include_building = False)
    shadows_all = shadows.geometry.unary_union
    parks_unshaded  = parks.geometry.difference(shadows_all)
    sunny_perc = parks_unshaded.area/parks.area * 100

    #Link with park names and return
    parks_tags = parks.tags.apply(pd.Series)
    parks_concat = pd.concat([parks_tags.name, sunny_perc], axis=1)
    top3 = parks_concat.sort_values(by=[0], ascending=False).head(3)
    return {'park1':top3.iloc[0,0],
            'park2':top3.iloc[1,0],
            'park3':top3.iloc[2,0],
            'park1_perc':top3.iloc[0,1],
            'park2_perc':top3.iloc[0,1],
            'park3_perc':top3.iloc[0,1],
           }


