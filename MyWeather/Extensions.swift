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

extension Double {
    func toCelsius() -> String {
        return (self - 273.15).roundDouble()+"°"
    }
}


extension TimeInterval {
    
    func toHM() -> String {
        let date = Date(timeIntervalSince1970: self)
        let calendar = Calendar.current

        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        return formatter.string(from: date)
    }
    
    func toWeekday() -> String {
        let date = Date(timeIntervalSince1970: self)
        let calendar = Calendar.current
        let weekday =  calendar.component(.weekday, from: date)
        let dict = [1: "Sun", 2: "Mon", 3: "Tue", 4: "Wed", 5: "Thu", 6: "Fri", 7: "Sat"]
        return dict[weekday] ?? ""
    }
}



extension Weather {
    func isDay() -> Bool {
        if (self.current.dt >= self.current.sunrise && self.current.dt <= self.current.sunset) {
            return true
        } else {
            return false
        }

    }
        
    func toWeatherIcon(day: Int) -> String {
        let isDay = self.isDay()
        var weatherId = self.current.weather[0].id
        if (day != -1) {
            weatherId = self.daily[day].weather[0].id
        }
        
        if (weatherId == 800) {
            if (isDay || day != -1) {
                return "SunnyDay"
            } else {
                return "SunnyNight"
            }
        } else if (weatherId == 801 || weatherId == 802) {
            if (isDay || day != -1) {
                return "PartlyCloudyDay"
            } else {
                return "PartlyCloudyNight"
            }
        } else if (weatherId == 803 || weatherId == 804) {
            return "Cloudy"
        } else if (weatherId >= 200 && weatherId <= 232) {
            return "Thunderstorm"
        } else if (weatherId >= 300 && weatherId <= 321) {
            return "Drizzle"
        } else if (weatherId >= 500 && weatherId <= 531) {
            return "Rain"
        } else if (weatherId >= 600 && weatherId <= 622) {
            return "Snow"
        } else {
            return "Mist"
        }
    }
    
    func toBackground() -> String {
        let isDay = self.isDay()
        if (self.current.weather[0].id == 800 || self.current.weather[0].id == 801 || self.current.weather[0].id == 802) {
            if (isDay) {
                return "SunnyBg"
            } else {
                return "SunnyNightBg"
            }
        } else if (self.current.weather[0].id == 803 || self.current.weather[0].id == 804) {
            if (isDay) {
                return "CloudsBg"
            } else {
                return "CloudyNightBg"
            }
        } else if (self.current.weather[0].id >= 200 && self.current.weather[0].id <= 232) {
            return "ThunderBg"
        } else if (self.current.weather[0].id >= 300 && self.current.weather[0].id <= 321) {
            return "DrizzleBg"
        } else if (self.current.weather[0].id >= 500 && self.current.weather[0].id <= 531) {
            return "RainBg"
        } else if (self.current.weather[0].id >= 600 && self.current.weather[0].id <= 622) {
            return "SnowBg"
        } else {
            return "MistBg"
        }
    }
    
}

extension Array {
    func deepRemove(at index: Index) -> [Element] {
        var newArray: [Element] = []
        //var i = 0
        for i in 0..<self.count {
            if (i != index) {
                newArray.append(self[i])
            }
        }
        //newArray.append(self[2])
        //newArray.append(self[1])
        return newArray
    }
}
