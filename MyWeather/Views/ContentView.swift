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
    var cityNameManager = CityNameManager()

    @State var weather: Weather?
    @State var weather1: Weather?
    @State var weather2: Weather?

    @State var cityName: String?
    @State private var refreshID = UUID() // Add a State variable to trigger refresh
    @State private var refreshID1 = UUID() // Add a State variable to trigger refresh
    @State private var refreshID2 = UUID() // Add a State variable to trigger refresh

    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                if let weather = weather,let weather1 = weather1, let weather2 = weather2, let cityName = cityName {
                    
                    TabView() {
                        WeatherView(weather: weather, city: cityName )
                            .id(refreshID)
                        WeatherView(weather: weather1, city: "Hangzhou" )
                            .id(refreshID1)
                        WeatherView(weather: weather2, city: "Beijing" )
                            .id(refreshID2)
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .edgesIgnoringSafeArea(.all)


                } else {
                    LoadingView()
                        .onAppear {
                            // Fetch initial data synchronously
                            Task {
                                do {
                                    weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                    weather1 = try await weatherManager.getCurrentWeather(latitude: 30, longitude: 120)
                                    weather2 = try await weatherManager.getCurrentWeather(latitude: 39.9042, longitude: 116.4074)

                                    cityName = try await cityNameManager.getCurrentCityName(latitude: location.latitude, longitude: location.longitude)
                                } catch {
                                    print("Error getting initial weather: \(error)")
                                }
                                
                                // Trigger the first refresh immediately
                                refreshData()
                                
                                // Start the repeating timer
                                let timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                                    refreshData()
                                }
                                RunLoop.current.add(timer, forMode: .common)
                            }
                        }
                }
            } else {
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    LoadingView()
                        .onAppear {
                            locationManager.requestLocation()
                        }
                }
            }
        }
        .background(Color(hue: 0.679, saturation: 0.833, brightness: 0.604))
        .preferredColorScheme(.dark)
    }
    
    // Function to refresh weather and city data
    func refreshData() {
        Task {
            do {
                guard let location = locationManager.location else { return }
                try await weather = weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                try await cityName = cityNameManager.getCurrentCityName(latitude: location.latitude, longitude: location.longitude)
                refreshID = UUID() // Trigger refresh
                
                guard let location = locationManager.location else { return }
                try await weather = weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                //try await city = weatherManager.getCurrentCity(latitude: location.latitude, longitude: location.longitude)
                refreshID1 = UUID() // Trigger refresh
                
                guard let location = locationManager.location else { return }
                try await weather = weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                //try await city = weatherManager.getCurrentCity(latitude: location.latitude, longitude: location.longitude)
                refreshID2 = UUID() // Trigger refresh

            } catch {
                print("Error getting weather: \(error)")
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
