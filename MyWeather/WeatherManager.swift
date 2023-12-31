//
//  WeatherManager.swift
//  MyWeather
//
//  Created by 张梓欣 on 9/5/23.
//

import Foundation
import CoreLocation

class WeatherManager {
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> Weather {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&appid=8f0253050fdf937f8ad745ed78e9ca17") else { fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data")}
        let res = try JSONDecoder().decode(Weather.self, from: data)
        print(res)
        return res
    }

}


struct Weather: Codable {

    var lat: Double
    var lon: Double
    var timezone_offset: Int
    var current: CurrentResponse
    var daily: [DailyResponse]
    
    struct CurrentResponse: Codable {
        var dt: TimeInterval
        var sunrise: TimeInterval
        var sunset: TimeInterval
        var temp: Double
        var wind_speed: Double
        var pressure: Int
        var humidity: Int
        var weather: [WeatherResponse]
    }

    struct DailyResponse: Codable {
        var dt: TimeInterval
        var sunrise: TimeInterval
        var sunset: TimeInterval
        var temp: TempResponse
        var wind_speed: Double
        var pressure: Int
        var humidity: Int
        var weather: [WeatherResponse]
        
        struct TempResponse: Codable {
            var min: Double
            var max: Double
        }
    }
    
    struct WeatherResponse: Codable {
        var id: Int
        var main: String
        var description: String
        var icon: String
    }
}

