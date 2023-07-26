//
//  ForecastData+CoreDataProperties.swift
//  DVT_WeatherApp
//
//  Created by Mani Yechuri on 2023/07/26.
//
//

import Foundation
import CoreData


extension ForecastData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ForecastData> {
        return NSFetchRequest<ForecastData>(entityName: "ForecastData")
    }

    @NSManaged public var weekday: String?
    @NSManaged public var image: String?
    @NSManaged public var degree: String?
    @NSManaged public var date: Date?

}

extension ForecastData : Identifiable {

}
