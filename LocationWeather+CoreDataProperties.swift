//
//  LocationWeather+CoreDataProperties.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/25.
//
//

import Foundation
import CoreData


extension LocationWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationWeather> {
        return NSFetchRequest<LocationWeather>(entityName: "LocationWeather")
    }

    @NSManaged public var descriptionn: String?
    @NSManaged public var icon: String?
    @NSManaged public var mainString: String?

}
