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
        
        do {
            try DatabaseHelper.shared.context.save()
            debugPrint("Able to save weather details to coredata ")
        }catch let error as NSError {
            debugPrint("Unable to save weather details to coredata : \(error), \(error.userInfo), \(error.localizedDescription)")
        }
    }
    
    func saveForecastWeatherData(forecase weather : ForecastWeatherData) {
        let entity = NSEntityDescription.entity(forEntityName: "ForecastData", in: context) ?? nil
        let weatherObject = ForecastData(entity: entity!, insertInto: context)
        weatherObject.cod = weather.cod
        weatherObject.cnt = Int64(weather.cnt)
//        weatherObject.list = weather.list
//        weatherObject.location = weather.city
        do {
            try self.context.save()
        }catch {
            debugPrint("Error in saving forecase details")
        }
        
    }
    
    func fetchCurrentWeatherData() -> WeatherData? {
        var currentWeather : WeatherData?
        let fetchRequest : NSFetchRequest<CurrentWeatherData> = CurrentWeatherData.fetchRequest()
        do {
            let result = try DatabaseHelper.shared.context.fetch(fetchRequest)
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
//                forecastWeatherData?.cnt = Int(dataItem.cnt)
//                forecastWeatherData?.cod = dataItem.cod ?? ""
//                forecastWeatherData?.city = dataItem.location
//                forecastWeatherData?.list = dataItem.list
            }
        }catch {
            print("Error while fetching forecast data")
        }
        return forecastWeatherData
    }
}
