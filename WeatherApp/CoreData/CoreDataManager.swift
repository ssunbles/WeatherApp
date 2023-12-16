//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by Айнур on 14.12.2023.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CityHistory")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - CRUD Operations

    func saveCity(name: String, latitude: Double, longitude: Double) {
        let existingCities = fetchAllCities()
        let duplicateCity = existingCities.first { city in
            return city.latitude == latitude && city.longitude == longitude
        }
        guard duplicateCity == nil else {
            return
        }

        let city = CityHistory(context: context)
        city.name = name
        city.latitude = latitude
        city.longitude = longitude
        saveContext()
    }


    func deleteCity(_ city: CityHistory) {
        context.delete(city)
        saveContext()
    }
    
    func deleteAllCities() {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CityHistory")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try persistentContainer.viewContext.execute(deleteRequest)
                print("Все данные удалены из Core Data.")
            } catch {
                print("Ошибка при удалении данных из Core Data: \(error.localizedDescription)")
            }
        }
    
    
    func fetchAllCities() -> [CityHistory] {
        let fetchRequest: NSFetchRequest<CityHistory> = CityHistory.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch cities: \(error)")
            return []
        }
    }


    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
