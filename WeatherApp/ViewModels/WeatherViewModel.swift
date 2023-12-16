//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Айнур on 12.12.2023.
//

import Foundation

class WeatherViewModel {
    private var latitude: Double?
    private var longitude: Double?

    init(latitude: Double?, longitude: Double?) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func fetchWeatherData(completion: @escaping (WeatherData?) -> Void) {
        guard let latitude = latitude, let longitude = longitude else {
            completion(nil)
            return
        }
        
        WeatherAPIService.shared.getCurrentWeather(latitude: latitude, longitude: longitude) { weatherData in
            DispatchQueue.main.async {
                completion(weatherData)
            }
        }
    }
    
    func fetchWeatherDataForFiveDays(completion: @escaping (WeatherDataForFiveDays?) -> Void) {
        guard let latitude = latitude, let longitude = longitude else {
            completion(nil)
            return
        }

        WeatherAPIService.shared.getWeatherForFiveDays(latitude: latitude, longitude: longitude) { weatherData in
            DispatchQueue.main.async {
                completion(weatherData)
            }
        }
    }
    
}
