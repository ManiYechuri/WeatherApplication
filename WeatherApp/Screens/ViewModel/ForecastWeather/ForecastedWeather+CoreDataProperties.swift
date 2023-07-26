//
//  ForecastedWeather+CoreDataProperties.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/26.
//
//

import Foundation
import CoreData


extension ForecastedWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastedWeather> {
        return NSFetchRequest<ForecastedWeather>(entityName: "ForecastedWeather")
    }

    @NSManaged public var cityID: Int64
    @NSManaged public var country: String?
    @NSManaged public var name: String?
    @NSManaged public var population: Int64
    @NSManaged public var sunrise: Int64
    @NSManaged public var sunset: Int64
    @NSManaged public var timezone: Int64
    @NSManaged public var coord: LocationCoordinates?

}

extension ForecastedWeather : Identifiable {

}
