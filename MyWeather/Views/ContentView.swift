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

    @State var weather: ResponseBody?
    @State var city: String?
    @State private var refreshID = UUID() // Add a State variable to trigger refresh
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                if let weather = weather, let city = city {
                    WeatherView(weather: weather, city: city )
                        .id(refreshID) // Use the State variable to trigger refresh
                } else {
                    LoadingView()
                        .onAppear {
                            // Fetch initial data synchronously
                            Task {
                                do {
                                    weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                    city = try await weatherManager.getCurrentCity(latitude: location.latitude, longitude: location.longitude)
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
                try await city = weatherManager.getCurrentCity(latitude: location.latitude, longitude: location.longitude)
                refreshID = UUID() // Trigger refresh
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
