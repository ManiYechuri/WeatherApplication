//
//  LocationCoordinates+CoreDataProperties.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/25.
//
//

import Foundation
import CoreData


extension LocationCoordinates {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationCoordinates> {
        return NSFetchRequest<LocationCoordinates>(entityName: "LocationCoordinates")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lon: Double

}
