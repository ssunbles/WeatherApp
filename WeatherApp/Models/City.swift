//
//  CityHistory+CoreDataProperties.swift
//  WeatherApp
//
//
//

import Foundation
import CoreData

@objc(City)
public class City: NSManagedObject {

}

extension City {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityHistory> {
        return NSFetchRequest<CityHistory>(entityName: "CityHistory")
    }

    @NSManaged public var name: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
}

extension City : Identifiable {

}
