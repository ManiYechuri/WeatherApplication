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
        return Helper.shared.getAppDelegate().persistentContainer.viewContext
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
        weatherObject.feelsLike = data.main?.feels_like ?? 0.0
        weatherObject.temperature = data.main?.temp ?? 0.0
        weatherObject.maxTemperature = data.main?.temp_max ?? 0.0
        weatherObject.minTemperature = data.main?.temp_min ?? 0.0
        for item in data.weather! {
            weatherObject.mainWeather = item.main
        }
        weatherObject.timezone = Int64(data.timezone)
        self.saveContext()
    }
    
    func saveForecastWeatherData(forecase weather : ForecastWeatherData) {
        let entity = NSEntityDescription.entity(forEntityName: "ForecastData", in: context) ?? nil
        if let exisitingData = fetchExistingData(entity: "ForecastData") {
            self.deleteData(dataObjects: exisitingData)
            saveContext()
        }
        let weatherObject = ForecastData(entity: entity!, insertInto: context)
        for data in weather.list {
            weatherObject.degree = Helper.shared.convertKelvinToCelsius(temp: data.main.temp, from: .kelvin, to: .celsius)
            for climate in data.weather {
                if climate.main == WeatherCondition.Clouds.rawValue {
                    weatherObject.image = "partlysunny"
                }else if climate.main == WeatherCondition.Clear.rawValue {
                    weatherObject.image = "clear"
                }else if climate.main == WeatherCondition.Rain.rawValue {
                    weatherObject.image = "rain"
                }
            }
            weatherObject.weekday = Helper.shared.getWeekdayFromDate(Date(timeIntervalSince1970: data.dt))
            weatherObject.date = Helper.shared.convertStringToDate(dateString: data.dt_txt)
        }
        self.saveContext()
    }
    
    func fetchCurrentWeatherData() -> [WeatherData] {
        var currentWeather = [WeatherData]()
        var weather = [Weather]()
        let fetchRequest : NSFetchRequest<CurrentWeatherData> = CurrentWeatherData.fetchRequest()
        do {
            let result = try DatabaseHelper.shared.context.fetch(fetchRequest)
            for dataItem in result {
                weather.append(Weather(id: Int(0), main: dataItem.mainWeather ?? "", description: "", icon: ""))
                currentWeather.append(WeatherData(weather : weather, base: dataItem.base ?? "", name: dataItem.name ?? "", main: Main(temp: dataItem.temperature, feels_like: dataItem.feelsLike, temp_min: dataItem.minTemperature, temp_max: dataItem.maxTemperature, pressure: 0, humidity: 0) ,dt: Int(dataItem.dt), timezone: Int(dataItem.timezone), id: Int(dataItem.id), cod: Int(dataItem.cod), visibility: Int(dataItem.visibility)))
            }
        }catch {
            print("Error while fetching data")
        }
        return currentWeather
    }
    
    func fetchForecastWeatherData() -> [DisplayForecastData] {
        var forecastWeatherData = [DisplayForecastData]()
        let fetchRequest : NSFetchRequest<ForecastData> = ForecastData.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            for dataItem in result {
                forecastWeatherData.append(DisplayForecastData(weekday: dataItem.weekday ?? "", image: dataItem.image ?? "", degree: dataItem.degree ?? "", date: dataItem.date ?? Date()))
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
