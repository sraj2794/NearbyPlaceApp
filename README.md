# NearbyPlaceApp
Nearby App is designed to help users discover venues around their current location, allowing them to find places to visit and potentially buy tickets. The app leverages location services to fetch venue data from a remote API and provides features for filtering venues by distance and searching by venue name. It supports local caching of venue data to enhance user experience and reduce network dependency.

Key Features:

Fetching Venues:

Venues are fetched from a remote API based on the user's current location.
Pagination is implemented to load additional venues as the user scrolls.
Filtering by Distance:

Users can adjust a slider to filter venues based on their distance from the current location.
Venues beyond the specified distance are filtered out dynamically.
Local Caching:

Venues fetched during the last session are cached locally.
Cached venues are displayed immediately upon app launch before a new network call retrieves the latest data.
Portrait Mode Only:

The app is optimized for portrait orientation to provide a consistent and intuitive user experience.
Search Functionality:

Users can search for venues by name locally within the cached data.
Search results update dynamically as the user types, enhancing usability.
Technologies Used:

Swift: Programming language used for iOS app development.
UIKit: Framework for building user interfaces.
Core Location: Framework for location services and geographical data.
URLSession: For making network requests to fetch venue data from the API.
JSONSerialization: For parsing JSON data received from the API.
UserDefaults: For storing and retrieving cached venue data locally.
