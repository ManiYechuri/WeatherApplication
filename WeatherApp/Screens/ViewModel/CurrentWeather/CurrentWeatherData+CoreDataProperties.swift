//
//  CurrentWeatherData+CoreDataProperties.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/26.
//
//

import Foundation
import CoreData


extension CurrentWeatherData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeatherData> {
        return NSFetchRequest<CurrentWeatherData>(entityName: "CurrentWeatherData")
    }

    @NSManaged public var base: String?
    @NSManaged public var cod: Int64
    @NSManaged public var dt: Int64
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var timezone: Int64
    @NSManaged public var visibility: Int64
    @NSManaged public var temperature: Double
    @NSManaged public var feelsLike: Double
    @NSManaged public var maxTemperature: Double
    @NSManaged public var minTemperature: Double
    @NSManaged public var mainWeather: String?

}

extension CurrentWeatherData : Identifiable {

}
