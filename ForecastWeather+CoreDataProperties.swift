//
//  ForecastWeather+CoreDataProperties.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/25.
//
//

import Foundation
import CoreData


extension ForecastWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastWeather> {
        return NSFetchRequest<ForecastWeather>(entityName: "ForecastWeather")
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

extension ForecastWeather : Identifiable {

}
