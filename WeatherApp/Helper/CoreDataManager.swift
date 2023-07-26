//
//  CoreDataManager.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/24.
//

import UIKit
import CoreData

class DatabaseHelper {
    
    static let shared = DatabaseHelper()
    private init (){}
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrentWeatherData")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context : NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveCurrentWeather(currentWeather data : WeatherData){
        let entity = NSEntityDescription.entity(forEntityName: "CurrentWeatherData", in: context) ?? nil
        if let exisitingData = fetchExistingData(entity: "CurrentWeatherData") {
            self.deleteData(dataObjects: exisitingData)
            saveContext()
        }
        let weatherObject = CurrentWeatherData(entity: entity!, insertInto: context)
        weatherObject.id = Int64(data.id)
        weatherObject.base = data.base
        weatherObject.cod = Int64(data.cod)
        weatherObject.dt = Int64(data.dt)
        weatherObject.name = data.name
        weatherObject.visibility = Int64(data.visibility)
        weatherObject.main?.feels_like = data.main.feels_like
        weatherObject.main?.humidity = Int64(data.main.humidity)
        weatherObject.main?.pressure = Int64(data.main.pressure)
        weatherObject.main?.temp = data.main.temp
        weatherObject.main?.temp_max = data.main.temp_max
        weatherObject.main?.temp_min = data.main.temp_min
        for item in data.weather {
            weatherObject.weather?.icon = item.icon
            weatherObject.weather?.mainString = item.main
            weatherObject.weather?.descriptionn = item.description
        }
        weatherObject.sys?.country = data.sys.country
        weatherObject.sys?.sunrise = Int64(data.sys.sunrise)
        weatherObject.sys?.sunset = Int64(data.sys.sunset)
        weatherObject.wind?.deg = Int64(data.wind.deg)
        weatherObject.wind?.speed = data.wind.speed
        weatherObject.wind?.gust = data.wind.gust ?? 0.0
        weatherObject.clouds?.all = Int64(data.clouds.all)
        weatherObject.timezone = Int64(data.timezone)
        weatherObject.coord?.lat = data.coord.lat
        weatherObject.coord?.lon = data.coord.lon
        
        self.saveContext()
    }
    
    func saveForecastWeatherData(forecase weather : ForecastWeatherData) {
        let entity = NSEntityDescription.entity(forEntityName: "ForecastData", in: context) ?? nil
        if let exisitingData = fetchExistingData(entity: "ForecastData") {
            self.deleteData(dataObjects: exisitingData)
            saveContext()
        }
        let weatherObject = ForecastData(entity: entity!, insertInto: context)
        weatherObject.cod = weather.cod
        weatherObject.cnt = Int64(weather.cnt)
        for listItem in weather.list {
            weatherObject.list?.clouds?.all = Int64(listItem.clouds.all)
            weatherObject.list?.dateText = listItem.dt_txt
            weatherObject.list?.dt = Int64(listItem.dt)
            weatherObject.list?.main?.feels_like = listItem.main.feels_like
            weatherObject.list?.main?.temp = listItem.main.temp
            weatherObject.list?.main?.humidity = Int64(listItem.main.humidity)
            weatherObject.list?.main?.pressure = Int64(listItem.main.pressure)
            weatherObject.list?.main?.temp_max = listItem.main.temp_max
            weatherObject.list?.main?.temp_min = listItem.main.temp_min
            weatherObject.list?.pop = listItem.pop
            weatherObject.list?.visibility = Int64(listItem.visibility)
            for item in listItem.weather {
                weatherObject.list?.weather?.icon = item.icon
                weatherObject.list?.weather?.mainString = item.main
                weatherObject.list?.weather?.descriptionn = item.description
            }
        }
        self.saveContext()
    }
    
    func fetchCurrentWeatherData() -> WeatherData? {
        var currentWeather : WeatherData?
        let fetchRequest : NSFetchRequest<CurrentWeatherData> = CurrentWeatherData.fetchRequest()
        do {
            let result = try DatabaseHelper.shared.context.fetch(fetchRequest)
            debugPrint("Fetched result : \(result)")
            for dataItem in result {
                currentWeather?.base = dataItem.base ?? ""
                currentWeather?.cod = Int(dataItem.cod)
                currentWeather?.id = Int(dataItem.id)
                currentWeather?.dt = Int(dataItem.dt)
                currentWeather?.visibility = Int(dataItem.visibility)
                currentWeather?.name = dataItem.name ?? ""
                currentWeather?.main.feels_like = dataItem.main?.feels_like ?? 0.0
                currentWeather?.main.humidity = Int(dataItem.main?.humidity ?? 0)
                currentWeather?.main.pressure = Int(dataItem.main?.pressure ?? 0)
                currentWeather?.main.temp = dataItem.main?.temp ?? 0.0
                currentWeather?.main.temp_max = dataItem.main?.temp_max ?? 0.0
                currentWeather?.main.temp_min = dataItem.main?.temp_min ?? 0.0
                currentWeather?.sys.country = dataItem.sys?.country ?? ""
                currentWeather?.sys.sunrise = Int(dataItem.sys?.sunrise ?? 0)
                currentWeather?.sys.sunset = Int(dataItem.sys?.sunrise ?? 0)
                currentWeather?.wind.deg = Int(dataItem.wind?.deg ?? 0)
                currentWeather?.wind.speed = dataItem.wind?.speed ?? 0.0
                currentWeather?.wind.gust = dataItem.wind?.gust ?? 0.0
                currentWeather?.clouds.all = Int(dataItem.clouds?.all ?? 0)
                currentWeather?.timezone = Int(dataItem.timezone)
                currentWeather?.coord.lat = dataItem.coord?.lat ?? 0.0
                currentWeather?.coord.lon = dataItem.coord?.lon ?? 0.0
                currentWeather?.weather.append(Weather(id: Int(dataItem.weather?.id ?? 0), main: dataItem.weather?.mainString ?? "", description: dataItem.weather?.descriptionn ?? "", icon: dataItem.weather?.icon ?? ""))
            }
        }catch {
            print("Error while fetching data")
        }
        return currentWeather
    }
    
    func fetchForecaseWeatherData() -> ForecastWeatherData? {
        var forecastWeatherData : ForecastWeatherData?
        let fetchRequest : NSFetchRequest<ForecastData> = ForecastData.fetchRequest()

        do {
            let result = try context.fetch(fetchRequest)
            for dataItem in result {
                forecastWeatherData?.cnt = Int(dataItem.cnt)
                forecastWeatherData?.cod = dataItem.cod ?? ""
                forecastWeatherData?.message = Int(dataItem.message)
                let dt = Int(dataItem.list?.dt ?? 0)
                let wind = Wind(speed: dataItem.list?.wind?.speed ?? 0.0, deg: Int(dataItem.list?.wind?.deg ?? 0))
                let clouds = Clouds(all: Int(dataItem.list?.clouds?.all ?? 0))
                let main = Main(temp: dataItem.list?.main?.temp ?? 0.0, feels_like: dataItem.list?.main?.feels_like ?? 0.0, temp_min: dataItem.list?.main?.temp_min ?? 0.0, temp_max: dataItem.list?.main?.temp_max ?? 0.0, pressure: Int(dataItem.list?.main?.pressure ?? 0), humidity: Int(dataItem.list?.main?.humidity ?? 0))
                let weather = Weather(id: 0, main: dataItem.list?.weather?.mainString ?? "", description: dataItem.list?.weather?.descriptionn ?? "", icon: dataItem.list?.weather?.icon ?? "")
                forecastWeatherData?.list.append(List(dt: TimeInterval(dt), weather: [weather], main: main, clouds: clouds, wind: wind, dt_txt: dataItem.list?.dateText ?? "", visibility: Int(dataItem.list?.visibility ?? 0), pop: 0.0))
            }
        }catch {
            print("Error while fetching forecast data")
        }
        return forecastWeatherData
    }
    
    func fetchExistingData(entity name : String) -> [NSManagedObject]?{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
        do {
            let fetchedData = try context.fetch(fetchRequest)
            return fetchedData
        }catch let error as NSError{
            debugPrint("Error fetching data : \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func deleteData(dataObjects : [NSManagedObject]){
        for dataObject in dataObjects {
            context.delete(dataObject)
        }
    }
    
    func saveContext(){
        do {
            try context.save()
        }catch let error as NSError {
            debugPrint("Error saving context : \(error), \(error.userInfo)")
        }
    }
}
