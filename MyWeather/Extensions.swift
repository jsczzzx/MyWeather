//
//  Extensions.swift
//  MyWeather
//
//  Created by 张梓欣 on 9/10/23.
//

import Foundation
import CoreLocation

extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}



extension ResponseBody {
    func isDay() -> Bool {
        var isDay = true
        let offset = TimeZone.current.secondsFromGMT();
        let loc = CLLocation.init(latitude: self.coord.lat, longitude: self.coord.lon);
        let coder = CLGeocoder();
        coder.reverseGeocodeLocation(loc) { (placemarks, error) in
            let place = placemarks?.last;
            
            let newOffset = place?.timeZone?.secondsFromGMT();
            
            let totalOffset = (newOffset ?? 0) - offset
            
            let currentTime = Date()
            let newTime = currentTime.addingTimeInterval(Double(totalOffset))
            
            let hour = Calendar.current.component(.hour, from: newTime)
            
            if (hour >= 6 && hour < 18) {
                isDay = true
            } else {
                isDay = false
            }
        }
        return isDay
    }
        
    func toWeatherIcon() -> String {
        let isDay = self.isDay()
        if (self.weather[0].id == 800) {
            if (isDay) {
                return "SunnyDay"
            } else {
                return "SunnyNight"
            }
        } else if (self.weather[0].id == 801 || self.weather[0].id == 802) {
            if (isDay) {
                return "PartlyCloudyDay"
            } else {
                return "PartlyCloudyNight"
            }
        } else if (self.weather[0].id == 803 || self.weather[0].id == 804) {
            return "Cloudy"
        } else if (self.weather[0].id >= 200 && self.weather[0].id <= 232) {
            return "Thunderstorm"
        } else if (self.weather[0].id >= 300 && self.weather[0].id <= 321) {
            return "Drizzle"
        } else if (self.weather[0].id >= 500 && self.weather[0].id <= 531) {
            return "Rain"
        } else if (self.weather[0].id >= 600 && self.weather[0].id <= 622) {
            return "Snow"
        } else {
            return "Mist"
        }
    }
    
}
