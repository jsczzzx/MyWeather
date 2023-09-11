//
//  WeatherManager.swift
//  MyWeather
//
//  Created by 张梓欣 on 9/5/23.
//

import Foundation
import CoreLocation

class WeatherManager {
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=40.713&lon=-70.006&appid=8f0253050fdf937f8ad745ed78e9ca17") else { fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching weather data")}
        
        /*do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            // Handle and process the JSON data here
            print("JSON Data: \(json)")
        } catch {
            print("Error parsing JSON: \(error)")
        }*/
        
        
        let res = try JSONDecoder().decode(ResponseBody.self, from: data)
        print(res)

        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        return decodedData
    }
    
    
}



struct ResponseBody: Decodable {

    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var wind: WindResponse
    
    var name: String

    
    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }
    
    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }
    
    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

struct ResponseBody2: Decodable {

    var lat: Double
    var lon: Double
    //var weather: [WeatherResponse]
    var daily: [WeatherResponse]
    
    struct CurrentResponse: Decodable {
        var sunrise: Int
        var sunset: Int
        var temp: Double
        var wind_speed: Double
        var pressure: Int
        var humidity: Int
    }

    
    
    struct WeatherResponse: Decodable {
        var sunrise: Int
        var sunset: Int
        var temp: tempResponse
        var wind_speed: Double
        var pressure: Int
        var humidity: Int
        var weather: weatherResponse
        
        struct tempResponse: Decodable {
            var min: Double
            var max: Double
        }
        
        struct weatherResponse: Decodable {
            var id: Double
            var main: String
            var description: String
            var icon: String
        }
    }
    

}
