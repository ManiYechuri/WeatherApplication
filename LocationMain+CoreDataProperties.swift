//
//  LocationMain+CoreDataProperties.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/25.
//
//

import Foundation
import CoreData


extension LocationMain {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationMain> {
        return NSFetchRequest<LocationMain>(entityName: "LocationMain")
    }

    @NSManaged public var feels_like: Double
    @NSManaged public var humidity: Int64
    @NSManaged public var pressure: Int64
    @NSManaged public var temp: Double
    @NSManaged public var temp_max: Double
    @NSManaged public var temp_min: Double

}
