//
//  ContentView.swift
//  MyWeather
//
//  Created by 张梓欣 on 8/30/23.
//

import SwiftUI

struct Location {
    var lat: Double
    var lon: Double
}


struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    //var cityNameManager = CityNameManager()

    
    @State var weathers: [Weather] = []
    @State var refreshIds: [UUID] = []
    
    @State var isLoaded = false
    
    //@State var cities: [Location]?
    

    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                if isLoaded {
                    TabView() {
                        ForEach(0..<weathers.count) { i in
                            WeatherView(weather: weathers[i], city: cities[i].name )
                                .id(refreshIds[i])
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .edgesIgnoringSafeArea(.all)


                } else {
                    LoadingView()
                        .onAppear {
                            Task {
                                for i in 0..<cities.count {
                                    do {
                                        weathers.append(try await weatherManager.getCurrentWeather(latitude: Double(cities[i].lat)!, longitude: Double(cities[i].lng)!))
                                        refreshIds.append(UUID())
                                        
                                    } catch {
                                        print("Error getting initial weather: \(error)")
                                    }
                                }
                                isLoaded = true
                            }

                            // Trigger the first refresh immediately
                            refreshData()
                                
                            // Start the repeating timer
                            let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                                refreshData()
                            }
                        RunLoop.current.add(timer, forMode: .common)
                        
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
        var i = 0
        Task {
            for i in 0..<cities.count {
                do {
                    weathers[i] = try await weatherManager.getCurrentWeather(latitude: Double(cities[i].lat)!, longitude: Double(cities[i].lng)!)
                    refreshIds[i] = UUID()
                    
                } catch {
                    print("Error getting initial weather: \(error)")
                }
            }
            isLoaded = true
        }
    }

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
