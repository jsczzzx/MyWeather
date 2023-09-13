//
//  WeatherView.swift
//  MyWeather
//
//  Created by 张梓欣 on 9/10/23.
//

import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody
    var city: String

    var body: some View {
        ZStack(alignment: .leading) {
            
            Image(weather.toBackground())
                .resizable()
                //.aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                //.aspectRatio(contentMode: .fill)


            VStack() {
                VStack(alignment: .leading, spacing: 5) {
                    Text(city)
                        .bold().font(.title)

                    Text("\(Date(timeIntervalSince1970: weather.current.dt).formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack {
                    HStack {
                        Image(weather.toWeatherIcon(day: -1))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100) // Adjust the size as needed
                        
                        Spacer()
                        
                        Text(weather.current.temp.toCelsius())
                            .font(.system(size: 100))
                            .fontWeight(.bold)
                            .padding()
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 20) {
                            HStack(spacing: 20) {
                                WeatherRow(logo: "thermometer", name: "Feels like", value: "8°")
                                WeatherRow(logo: "thermometer", name: "Feels like", value: "8°")
                            }
                            HStack(spacing: 20) {
                                WeatherRow(logo: "thermometer", name: "Feels like", value: "8°")
                                WeatherRow(logo: "thermometer", name: "Feels like", value: "8°")
                            }

                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 40.0))
                        

                        
                        VStack(alignment: .leading, spacing: 0) {

                            DailyRow(weather: weather, day: 0)
                            
                            DailyRow(weather: weather, day: 1)

                            DailyRow(weather: weather, day: 2)

                            DailyRow(weather: weather, day: 3)

                            DailyRow(weather: weather, day: 4)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        //.padding(.bottom, 100)
                        .foregroundColor(.white)
                        //.background(.white)
                        //.cornerRadius(40)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 40.0)
                        )
                        

                        
                        Spacer()
                    }
                    

                }
                
                VStack {
                    //Spacer()
                    

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
        WeatherView(weather: previewWeather, city: "New York")
    }
}
