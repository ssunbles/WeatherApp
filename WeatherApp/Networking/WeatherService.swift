//
//  WeatherService.swift
//  WeatherApp
//
//

import Foundation
//MARK: - WeatherError
enum WeatherError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
}
//MARK: - ApiType
enum ApiType {
    case getCurrentWeather(latitude: Double, longitude: Double)
    case getWeatherForFiveDays(latitude: Double, longitude: Double)
    
    var baseURL: String {
        return "https://api.openweathermap.org/data/2.5/"
    }
    

    var path: String {
        switch self {
        case .getCurrentWeather(let latitude, let longitude):
            return "weather?lat=\(latitude)&lon=\(longitude)&units=metric&lang=ru&APPID=b420904c526075e639c2e4098af653d6"
        case .getWeatherForFiveDays(let latitude, let longitude):
            return "forecast?lat=\(latitude)&lon=\(longitude)&appid=b420904c526075e639c2e4098af653d6&lang=ru&units=metric"
        }
    }

    var request : URLRequest {
        let url = URL(string: path, relativeTo: URL(string: baseURL)!)!
        var request = URLRequest(url: url)
        switch self {
        case .getCurrentWeather :
            request.httpMethod = "GET"
            return request
        case .getWeatherForFiveDays:
            request.httpMethod = "GET"
            return request
        }
    }
}
//MARK: - WeatherAPIService
class WeatherAPIService {
    static let shared = WeatherAPIService()
    //MARK: - getCurrentWeather
    func getCurrentWeather(latitude: Double, longitude: Double, completion: @escaping (WeatherData?) -> Void) {
        let apiType = ApiType.getCurrentWeather(latitude: latitude, longitude: longitude)

        guard let url = URL(string: apiType.baseURL + apiType.path) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }

            do {
                let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                completion(weatherData)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
    //MARK: - getWeatherForFiveDays
    func getWeatherForFiveDays(latitude: Double, longitude: Double, completion: @escaping (WeatherDataForFiveDays?) -> Void) {
        let apiType = ApiType.getWeatherForFiveDays(latitude: latitude, longitude: longitude)

        guard let url = URL(string: apiType.baseURL + apiType.path) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }

            do {
                let weatherDataForFiveDays = try JSONDecoder().decode(WeatherDataForFiveDays.self, from: data)
                completion(weatherDataForFiveDays)
            } catch {
                print("Error decoding data: \(error)")
                completion(nil)
            }
        }
        task.resume()
    }
}
