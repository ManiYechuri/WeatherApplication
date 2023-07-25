//
//  LocationSystem+CoreDataProperties.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/25.
//
//

import Foundation
import CoreData


extension LocationSystem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationSystem> {
        return NSFetchRequest<LocationSystem>(entityName: "LocationSystem")
    }

    @NSManaged public var country: String?
    @NSManaged public var sunrise: Int64
    @NSManaged public var sunset: Int64

}
