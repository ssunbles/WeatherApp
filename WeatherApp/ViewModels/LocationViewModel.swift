//
//  LocationViewModel.swift
//  WeatherApp
//
//  Created by Айнур on 12.12.2023.
//

import Foundation
import CoreLocation
import UIKit

// MARK: - LocationViewModelDelegate
protocol LocationViewModelDelegate: AnyObject {
    func didTapDetectLocationButton(latitude: Double, longitude: Double, city: String)
    func didTapManuallyButton()
}

// MARK: - LocationViewModel
class LocationViewModel: NSObject, CLLocationManagerDelegate {
    weak var delegate: LocationViewModelDelegate?
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
    }

    // MARK: - setupLocationManager
    private func setupLocationManager() {
        DispatchQueue.global(qos: .background).async {
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.locationManager.delegate = self
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    self.locationManager.pausesLocationUpdatesAutomatically = false
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.startUpdatingLocation()
                }
            } else {
                let alert = UIAlertController(title: "Геолокация отключена", message: "Для определения местоположения включите геолокацию в настройках устройства.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }

    // MARK: - detectLocationButtonTapped
    func detectLocationButtonTapped() {
        setupLocationManager()
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        // Обратное декодирование
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Ошибка обратного декодирования \(error.localizedDescription)")
            } else if let placemarks = placemarks?.first {
                if let city = placemarks.locality {
                    print(city)
                    CoreDataManager.shared.saveCity(name: city, latitude: latitude, longitude: longitude)
                    self.delegate?.didTapDetectLocationButton(latitude: latitude, longitude: longitude, city: city)
                }
            }
        }
    }

    // MARK: - locationManager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Геолокация возвращена с ошибкой: \(error.localizedDescription)")
    }

    // MARK: - manuallyButtonTapped
    func manuallyButtonTapped() {
        delegate?.didTapManuallyButton()
    }
}
