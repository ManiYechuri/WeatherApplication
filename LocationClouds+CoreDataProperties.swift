//
//  LocationClouds+CoreDataProperties.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/25.
//
//

import Foundation
import CoreData


extension LocationClouds {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationClouds> {
        return NSFetchRequest<LocationClouds>(entityName: "LocationClouds")
    }

    @NSManaged public var all: Int64

}
