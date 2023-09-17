//
//  CityNameManager.swift
//  MyWeather
//
//  Created by 张梓欣 on 9/16/23.
//

import Foundation
import CoreLocation

class CityNameManager {


    func getCurrentCityName(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> String {
        
        guard let url = URL(string: "https://api.openweathermap.org/geo/1.0/reverse?lat=\(latitude)&lon=\(longitude)&appid=8f0253050fdf937f8ad745ed78e9ca17") else { fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error fetching city data")}
        let res = try JSONDecoder().decode([CityName].self, from: data)
        return res[0].local_names.en
    }
}

struct CityName: Codable {
    var local_names: LocalNameResponse
    
    struct LocalNameResponse: Codable {
        var en: String
    }
}
