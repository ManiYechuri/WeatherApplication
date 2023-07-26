//
//  LocationWind+CoreDataProperties.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/25.
//
//

import Foundation
import CoreData


extension LocationWind {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationWind> {
        return NSFetchRequest<LocationWind>(entityName: "LocationWind")
    }

    @NSManaged public var deg: Int64
    @NSManaged public var gust: Double
    @NSManaged public var speed: Double

}
