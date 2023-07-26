//
//  LocationList+CoreDataProperties.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/25.
//
//

import Foundation
import CoreData


extension LocationList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationList> {
        return NSFetchRequest<LocationList>(entityName: "LocationList")
    }

    @NSManaged public var dateText: String?
    @NSManaged public var dt: Int64
    @NSManaged public var pop: Float
    @NSManaged public var visibility: Int64
    @NSManaged public var clouds: LocationClouds?
    @NSManaged public var main: LocationMain?
    @NSManaged public var weather: LocationWeather?
    @NSManaged public var wind: LocationWind?

}

extension LocationList : Identifiable {

}
