I have implemented this weather application using MVVM architecture with closure data binding.
I have divided all the files into specific folder as specified below :
Application folder contains appdelegate and scene delegate files.

Appdelegate file contains all initialization code like coredata and network monitor (Checking for internet connection).

Constant folder contains all API with base url, all the api's are written with enumerations

In the extensions folder i have written multiple enumerations which are useful in fetching data from API.

In the Helper folder i have added all files which can be used in implementing weather API .

In the api manager class i have declared singleton class for API Manager so it can be accesses anywhere in the current module without creating any object. This class is not marked as final because it cannot be accessible while writing unit tests.

Helper class contains functions related to converting date string to date and function related to converting temperature into celsius degree.

and also written one extension for uicolor which can be access using hex code in the code.

Coredata Manager contains logic related to save,fetch and update records. It is also a singleton class where we can access this class without creating object.

network manager is the class where we are monitoring internet access to our mobile thorugh data/WIFI. if user loses internet connection then we will update it with one boolean value called "isConnected".

Location manager is the class where we are getting user location based on user current location by implementing location delegate methods. to get users location we have to take permission for user by writing it in plist.

Screens folder contains the app architecture (MVVM). Model contains data according to our api response that are delcared in structs.

In model folder i declared two structs "WeatherData" represents Current weather data model and "Forecast weather data " represents forecase data model.

View folder contains  view controller files where user can see on the device

"Weather view controller" - to display current weather data forecast weather data for next 5 days with 3 hour range. As soon as the view loads we are writing a function called "Configuration" - it contains tableview initialization code and view model initialization so that as soon as view model is initialized we will call fetch current weather api and forecase api data. All these api events are handled by an enum called "Event". it is being observed in viewcontroller class and updated UI to user instantly. Databinding is done through Closure.

API response is decoded by using Decodable protocol where data models are declared as structs by confirming to decodable protocol.

"Weather Table cell " - displays forecast data that is fetched using forecast api.

View Model folder contains "Current weather view model" and "Forecast data view model" classes - all api events handled and updated to view by capturing model data.


"Current Weather" & "ForecastWeather" - this folder contains all class files related to coredata that are created automatically by coredata using xcode tool

written unit tests for API calls and they are being passed. i have checked  Nil and Not nil values for unit testing.
