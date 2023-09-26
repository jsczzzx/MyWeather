//
//  CityManager.swift
//  MyWeather
//
//  Created by 张梓欣 on 9/16/23.
//

import Foundation

class CityManager {

}

struct City: Codable {
    var city: String
    var city_ascii: String
    var lat: Double
    var lng: Double
    var country: String
    var iso2: String
    var iso3: String
    var admin_name: String
    var population: Int
    var id: Int
}
