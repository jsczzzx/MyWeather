//
//  ContentView.swift
//  MyWeather
//
//  Created by 张梓欣 on 8/30/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()

    @State var weather: ResponseBody? //What is @State
    @State var city: String?
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                if let weather = weather/*, let city = city*/ {
                    WeatherView(weather: weather, city: city ?? "")
                } else {
                    LoadingView()
                        .task {
                            do {
                                try await weather = weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                try await city = weatherManager.getCurrentCity(latitude: location.latitude, longitude: location.longitude)

                            } catch {
                                print("Error getting weather: \(error)")
                            }
                        }
                }
            } else {
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        .background(Color(hue: 0.679, saturation: 0.833, brightness: 0.604))
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
