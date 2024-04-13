# SunChaser

This repository contains the code and associated project documentation for the SunChaser mobile application. SunChaser is a handy app that tells you where is the best park close to you to get some sunshine. It utilizes sun positioning algorithms, combined with local weather data and an approximation of building heights in the city to give users the best approximation of where the sunniest parks are.

This mobile application was created as part of the course CASA0015 Mobile Systems and Interactions.

## Concept & Development

The initial concept was sketched out on paper as a simple storyboard:

<img width="500" alt="storyboard" src="https://github.com/ethmacc/casa0015-sunchaser/assets/60006290/97da23a4-e51b-45ef-8e2a-7ab5795c61c7">

This was then developed into a more fleshed out Figma wireframe:

![Mobile Wireframe UI Kit (Community)](https://github.com/ethmacc/casa0015-sunchaser/assets/60006290/24ca1a8f-61cb-4fb7-9977-5e84c67b5fdf)

User personas were also developed to assist in understanding user's needs and aspirations:

<img width="500" alt="persona1" src="https://github.com/ethmacc/casa0015-sunchaser/assets/60006290/756d1ebb-a81d-4a12-82cb-b56186ecc7d3">

<img width="500" alt="persona2" src="https://github.com/ethmacc/casa0015-sunchaser/assets/60006290/c6a959f9-9b17-48e9-89ab-3ab03d8daff5">

<img width="500" alt="persona3" src="https://github.com/ethmacc/casa0015-sunchaser/assets/60006290/54d846a8-0e83-426b-9cec-ef0e01094ab6">

## Key features

The key features are as follows:
- A map provided by OpenStreetMap to show users their current location (location services must be enabled)
- A sun finder function to help users find the top 5 sunniest parks closest to them (or a specified location)
- A routing function to show the way to these top 5 parks
- A sun intake counter to count the number of minutes the user spends in outdoor sunlight

The demo video can be found below:

https://github.com/ethmacc/casa0015-sunchaser/assets/60006290/a0718f42-89c5-48f3-8bed-679e222dd127

## Dependencies
Dependencies are listed in the ```pubspec.yaml``` file in the root folder. Dependencies for the python backend function can be found in ```firebase/functions/requirements.txt```, and can be installed as part of the process of setting up firebase Cloud Functions (https://firebase.google.com/docs/functions/get-started?gen=2nd).

## Installation

Release versions:
- For release versions, simply download and install the .apk file to your Android device.

Development version:
- If you would like to run the app in flutter, clone this repository to your machine and install flutter (https://flutter-ko.dev/get-started/install) if you don't already have the SDK.
- Change directory to the repo folder and run ```flutter create . ``` to repair the folder and add any missing files. You will need to add a ```.env``` file to the ```assets``` folder and provide your own API key for Open Weather.
  - Within ```.env``` the variable should be named as such: ```API_KEY = YOUR_API_KEY```
  - Presently, the curent version of the app uses the free-tier API key.
- The backend code is available in the ```firebase``` folder. To get this running, you will need to set up an account with firebase (https://firebase.google.com/) and deploy the folder using Cloud Functions (https://firebase.google.com/docs/functions). The app cannot function without the backend.

## Future implementations

- Implement the settings menu toggle as shown in the wireframe
- Swap out the OSM services with a more reliable paid service, e.g. Google for the production version
- Provide a heliodon / solar bracelet visualization
- Implement user accounts and sun log saving for each user

##  Contact Details

If you'd like to contribute to the app, please contact me via GitHub.

## Credits / References
- Sun and running man icons in the wireframe were sourced from the Noun Project (https://thenounproject.com/)
- Adobe Firefly, an AI Diffuser image model was used to create the app icons used in the final prototype and demo video
