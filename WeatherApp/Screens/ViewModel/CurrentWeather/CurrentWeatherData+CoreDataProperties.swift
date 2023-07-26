//
//  CurrentWeatherData+CoreDataProperties.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/25.
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
    @NSManaged public var clouds: LocationClouds?
    @NSManaged public var coord: LocationCoordinates?
    @NSManaged public var main: LocationMain?
    @NSManaged public var sys: LocationSystem?
    @NSManaged public var weather: LocationWeather?
    @NSManaged public var wind: LocationWind?

}

extension CurrentWeatherData : Identifiable {

}
