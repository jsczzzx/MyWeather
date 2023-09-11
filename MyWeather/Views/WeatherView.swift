//
//  WeatherView.swift
//  MyWeather
//
//  Created by 张梓欣 on 9/10/23.
//

import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody
    var body: some View {
        ZStack(alignment: .leading) {
            
            Image("SunnyBg")
                .resizable()
                .edgesIgnoringSafeArea(.top)

            VStack() {
                VStack(alignment: .leading, spacing: 5) {
                    Text(weather.name)
                        .bold().font(.title)
                    
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))").fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack {
                    HStack {
                        Image(weather.toWeatherIcon())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100) // Adjust the size as needed
                        
                        Spacer()
                        
                        Text((weather.main.feels_like - 273.15).roundDouble() + "°")
                            .font(.system(size: 100))
                            .fontWeight(.bold)
                            .padding()
                    }
                    
                    Spacer()
                }
                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)



            
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(red:0.4, green:0.4, blue:0.4))
        .preferredColorScheme(.dark)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather)
    }
}
