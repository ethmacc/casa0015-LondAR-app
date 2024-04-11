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

pd.options.mode.chained_assignment = None #suppress SettingWithCopyWarning
initialize_app()

@https_fn.on_call(
    enforce_app_check=True  # Reject requests with missing or invalid App Check tokens.
)
def calcParkShading(req: https_fn.Request) -> https_fn.Response:
    """Take the coordinate and datetime values passed to this parameter and return a list of the top 3 sunniest parks within  a box of approx 1km by 1km"""
    #query = json.loads(req.data)
    lat = float(req.data["lat"])
    long = float(req.data["long"])
    if lat is None or long is None:
        return https_fn.Response("One or more coordinate parameters are missing", status=400)
        
    date = str(req.data["dateStr"])
    time = str(req.data["timeStr"])
    if date is None or time is None:
        return https_fn.Response("One or more datetime parameters are missing", status=400)
    
    # fetch all ways and nodes
    overpass_url = "http://overpass-api.de/api/interpreter"
    query = f"""
        [out:json];
        (
        way(around:500, {lat}, {long}) ["leisure"="park"];
        way(around:500, {lat}, {long}) ["building"];
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
    
    levels = temp['building:levels'].fillna(1).astype(str)
    levels = levels.str.extract('(\d+)', expand=False)

    if 'height' in temp.columns:
        approx_ht = temp.height.fillna(round(levels.astype(int) * 128/36))
    else:
        approx_ht = round(levels.astype(int) * 128/36)

    geojsonDF['height'] = approx_ht.astype(str)
    geojsonDF['height'] = geojsonDF['height'].str.extract('(\d+)', expand=False)
    geojsonDF['height'] = geojsonDF['height'].astype(int)
    geojsonDF['leisure'] = temp.leisure
    geojsonDF.loc[geojsonDF['leisure'] == 'park', 'height'] = 0
    parks = geojsonDF.loc[geojsonDF['leisure'] == 'park']
    mass = geojsonDF.loc[geojsonDF['leisure'] != 'park']

    if len(parks) == 0:
        return {0:"No parks"}
    
    buildings = pybdshadow.bd_preprocess(mass)
    
    #Given UTC time
    date = pd.to_datetime(f'{date} {time}')\
        .tz_localize('Europe/London')\
        .tz_convert('UTC')
    
    #Calculate shadows
    try:
        shadows = pybdshadow.bdshadow_sunlight(buildings,date,roof=True,include_building = False)
    except ValueError:
        return {0:"After sunset"}
    
    shadows_all = shadows.geometry.unary_union
    parks_unshaded  = parks.geometry.difference(shadows_all)
    sunny_perc = parks_unshaded.area/parks.area * 100

    #Link with park names and return
    parks_tags = parks.tags.apply(pd.Series)
    print(type(parks_tags.name), type(sunny_perc), type(parks.centroid.get_coordinates()))
    parks_concat = pd.concat([parks_tags.name, sunny_perc, parks.centroid.get_coordinates()], axis=1)
    top3 = parks_concat.sort_values(by=[0], ascending=False).head(5)
    top3 = top3.rename(columns={0:'perc', 'x':'long', 'y':'lat'}).reset_index(drop=True)
    top3.name = top3.name.fillna('Unnamed')
    return_dict = top3.to_dict('index')
    
    return return_dict