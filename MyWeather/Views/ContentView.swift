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

var weatherManager = WeatherManager()
var cityNameManager = CityNameManager()




struct ContentView: View {
    @StateObject var locationManager = LocationManager()


    @State var weathers: [Weather] = []
    //@State var refreshIds: [UUID] = []


    
    @State var currentWeather = previewWeather
    @State var currentCityName = ""
    //@State var currentID = UUID()
    
    @State var selectedTabIndex: Int = -1

    
    @State var isLoaded = false
    @State var showSearchView = false
    
    //@State var cities: [Location]?
    

    
    var body: some View {
        ZStack {
            VStack {
                if let location = locationManager.location {
                    if isLoaded {
                        TabView(selection: $selectedTabIndex) {
                            WeatherView(weather: currentWeather, city: currentCityName)
                                .tag(-1)
                            ForEach(weathers.indices, id: \.self) { i in
                                WeatherView(weather: weathers[i], city: cities[i].city )
                                    .tag(i)
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
                                        //currentID = UUID()
                                        for i in 0..<cities.count {
                                            weathers.append(try await weatherManager.getCurrentWeather(latitude: cities[i].lat, longitude: cities[i].lng))
                                            //refreshIds.append(UUID())
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
                    .sheet(isPresented: $showSearchView, onDismiss: ({
                        refreshData(location: locationManager.location!)
                        selectedTabIndex = weathers.count
                        
                    })) {
                        SearchView(showSearchView: $showSearchView)
                            .presentationBackground(.clear)

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
                //currentID = UUID()
                
                if (location != nil) {
                    
                    for i in 0..<weathers.count {
                        weathers[i] = try await weatherManager.getCurrentWeather(latitude: cities[i].lat, longitude: cities[i].lng)
                        //refreshIds[i] = UUID()
                        
                    }
                    
                    for i in weathers.count..<cities.count {
                        weathers.append(try await weatherManager.getCurrentWeather(latitude: cities[i].lat, longitude: cities[i].lng))
                        //refreshIds.append(UUID())
                    }}
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
