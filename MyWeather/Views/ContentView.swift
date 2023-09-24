//
//  ContentView.swift
//  MyWeather
//
//  Created by 张梓欣 on 8/30/23.
//

import SwiftUI
import CoreLocation


struct Location {
    var lat: Double
    var lon: Double
}


struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    var cityNameManager = CityNameManager()

    
    @State var weathers: [Weather] = []
    @State var refreshIds: [UUID] = []
    
    @State var currentWeather = previewWeather
    @State var currentCityName = ""
    @State var currentID = UUID()
    
    @State var isLoaded = false
    @State var showSearchView = false
    
    //@State var cities: [Location]?
    

    
    var body: some View {
        ZStack {
            VStack {
                if let location = locationManager.location {
                    if isLoaded {
                        TabView() {
                            WeatherView(weather: currentWeather, city: currentCityName)
                                .tag(currentID)
                            ForEach(0..<weathers.count) { i in
                                WeatherView(weather: weathers[i], city: cities[i].name )
                                    .tag(refreshIds[i])
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .edgesIgnoringSafeArea(.all)
                        
                        
                    } else {
                        LoadingView()
                            .onAppear {
                                Task {
                                    do {
                                        currentWeather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                        currentCityName = try await cityNameManager.getCurrentCityName(latitude: location.latitude, longitude: location.longitude)
                                        currentID = UUID()
                                        for i in 0..<cities.count {
                                            weathers.append(try await weatherManager.getCurrentWeather(latitude: Double(cities[i].lat)!, longitude: Double(cities[i].lng)!))
                                            refreshIds.append(UUID())
                                            
                                        }
                                    } catch {
                                        print("Error getting initial weather: \(error)")
                                    }
                                    isLoaded = true
                                    
                                }
                                
                                // Trigger the first refresh immediately
                                //refreshData()
                                
                                // Start the repeating timer
                                let timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                                    refreshData(location: location)
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
            
            if isLoaded {
                
                VStack() {
                    Spacer()
                    
                    
                    Button(action: {
                        showSearchView.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:50)
                            .foregroundStyle(.white)
                    }
                    .sheet(isPresented: $showSearchView) {
                        SearchView()
                    }
                    
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    
    // Function to refresh weather and city data
    func refreshData(location: CLLocationCoordinate2D) {
        var i = 0
        Task {
            do {
                currentWeather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                currentCityName = try await cityNameManager.getCurrentCityName(latitude: location.latitude, longitude: location.longitude)
                currentID = UUID()
                for i in 0..<cities.count {
                    weathers[i] = try await weatherManager.getCurrentWeather(latitude: Double(cities[i].lat)!, longitude: Double(cities[i].lng)!)
                    refreshIds[i] = UUID()
                    
                }
            } catch {
                print("Error getting initial weather: \(error)")
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
