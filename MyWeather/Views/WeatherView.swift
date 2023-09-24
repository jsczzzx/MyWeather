//
//  WeatherView.swift
//  MyWeather
//
//  Created by 张梓欣 on 9/10/23.
//

import SwiftUI

struct WeatherView: View {
    @State var weather: Weather
    @State var city: String
    @State var currentDate = Date()
    @State var currentCity = ""

    
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
                    
                    Text("\((currentDate + TimeInterval(weather.timezone_offset)-TimeInterval(TimeZone.current.secondsFromGMT())).formatted(.dateTime.month().day().hour().minute().second()))")
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .onAppear {
                    // Start a repeating Timer that fires every second to update the date
                    let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                        currentDate = Date()
                    }
                    
                    // Make sure to add the timer to the run loop
                    RunLoop.current.add(timer, forMode: .common)
                }
                
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
                                WeatherRow(logo: "wind", name: "Wind", value: "\(weather.current.wind_speed.rounded()) m/s")
                                WeatherRow(logo: "drop", name: "Humidity", value: "\(weather.current.humidity) %")
                            }
                            HStack(spacing: 20) {
                                WeatherRow(logo: "sunrise", name: "Sunrise", value: "\(TimeInterval(weather.current.sunrise + TimeInterval(weather.timezone_offset) - TimeInterval(TimeZone.current.secondsFromGMT())).toHM())")
                                WeatherRow(logo: "sunset", name: "Sunset", value: "\(TimeInterval(weather.current.sunset + TimeInterval(weather.timezone_offset) - TimeInterval(TimeZone.current.secondsFromGMT())).toHM())")
                                
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
                
                /*TabView() {
                    Text("111111111111")
                    Text("222222222222")
                    Text("333333333333")

                }*/
                .tabViewStyle(.page)

                /*TabView {
                    Text("First")
                    Text("Second")
                    Text("Third")
                    Text("Fourth")
                }
                .tabViewStyle(.page)*/

                
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
