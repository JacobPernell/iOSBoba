# iOSBoba - Boba App

## Description
Basic mobile app where you can plug in a location (or let the app find your current location), and the app will tap into the Yelp API (or equivalent) to discover the closest boba shop, and will display directions to that location using MapKit. This project is intended to be practice for handling multiple screens/navigation, user location and location permissions, external APIs, and iOS framework integration.

As a v2 stretch goal, I will also implement user accounts (e.g. basic settings, favorite places), with login/auth and data storage handled via Firebase.

Some initial/high-level thoughts about the different tasks needed:
## v1 Tasks
- Location screen: input a zip code or let the user use their phone location (will require permissions) to use for search
- Yelp API (or similar API) using the location to search for boba shops nearby
- Map screen: display a map with iOS MapKit, navigating from the user's entered location to the selected boba shop
- List of stores screen: have some way to display a list of the top ~10 options from the API call results (e.g. map on top, list on bottom? card that pulls up with the list of nearby shops?) so the user can select other shops and see the map update directions accordingly

## v2 Tasks / Stretch Goal
- User login / auth with Firebase (e.g. Login with Apple / Google / etc.)
- Save favorites to account (with Firebase data persistence)
