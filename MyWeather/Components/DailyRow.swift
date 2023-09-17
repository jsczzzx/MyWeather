//
//  DailyRow.swift
//  MyWeather
//
//  Created by 张梓欣 on 9/13/23.
//

import SwiftUI

let screenSize: CGRect = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height

struct DailyRow: View {
    

    var weather: Weather
    var day: Int
    
    var body: some View {
        HStack(spacing: 20) {
            HStack() {
                if (day == 0) {
                    Text("Today")
                        .font(.headline)
                } else {
                    Text("\((weather.daily[day].dt).toWeekday())")
                        .font(.headline)
                }
            }
            .frame(width: screenWidth/6, alignment: .leading)

            HStack() {
                Image(weather.toWeatherIcon(day: day))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
            }
            .frame(width: screenWidth/6)



            HStack() {
                Text("\(weather.daily[day].temp.min.toCelsius()) ~ \(weather.daily[day].temp.max.toCelsius())")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, alignment: .center)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(5)

    }
}

struct DailyRow_Previews: PreviewProvider {
    static var previews: some View {
        DailyRow(weather: previewWeather, day: 0)
    }
}
