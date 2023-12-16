//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Айнур on 12.12.2023.
//

import Foundation
import CoreLocation
import CoreData

// MARK: - SearchViewControllerDelegate
protocol SearchViewControllerDelegate: AnyObject {
    func didTapSearchButton(cityName: String, latitude: Double, longitude: Double)
    func didLoadCities()
}

// MARK: - SearchViewModel
class SearchViewModel {
    weak var delegate: SearchViewControllerDelegate?
    var cities: [CityHistory] = []

    func searchButtonTap(with cityName: String) {
        getLocation(for: cityName)
    }

    func loadCities() {
        cities = CoreDataManager.shared.fetchAllCities()
        delegate?.didLoadCities()
    }

    // MARK: - getLocation
    private func getLocation(for cityName: String) {
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(cityName) { [weak self] (placemarks, error) in
            guard let self = self else { return }

            if let error = error {
                print("Ошибка геокодирования: \(error.localizedDescription)")
            } else if let placemark = placemarks?.first {
                let latitude = placemark.location?.coordinate.latitude ?? 0.0
                let longitude = placemark.location?.coordinate.longitude ?? 0.0

                CoreDataManager.shared.saveCity(name: cityName, latitude: latitude, longitude: longitude)
                self.delegate?.didTapSearchButton(cityName: cityName, latitude: latitude, longitude: longitude)
            }
        }
    }
}
