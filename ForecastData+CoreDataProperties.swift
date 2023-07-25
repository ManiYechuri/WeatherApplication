//
//  ForecastData+CoreDataProperties.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/25.
//
//

import Foundation
import CoreData


extension ForecastData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastData> {
        return NSFetchRequest<ForecastData>(entityName: "ForecastData")
    }

    @NSManaged public var cnt: Int64
    @NSManaged public var cod: String?
    @NSManaged public var message: Int64
    @NSManaged public var list: LocationList?
    @NSManaged public var location: ForecastWeather?

}

extension ForecastData : Identifiable {

}
