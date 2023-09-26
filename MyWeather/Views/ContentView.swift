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


    
    @State var localWeather = previewWeather
    @State var localCityName = ""
    @State var currentId = -1
    //@State var currentID = UUID()
    
    @State var tabIndex: Int = -1

    
    @State var isLoaded = false
    @State var showSearchView = false
    
    //@State var cities: [Location]?
    

    
    var body: some View {
        ZStack {
            VStack {
                if let location = locationManager.location {
                    if isLoaded {
                        TabView(selection: $tabIndex) {
                            WeatherView(weather: localWeather, city: localCityName)
                                .tag(-1)
                            ForEach(weathers.indices, id: \.self) { i in
                                WeatherView(weather: weathers[i], city: cities[i].city )
                                    .tag(i)
                            }
                        }
                        .onChange(of: tabIndex) { newValue in
                             print("New page: \(newValue)")
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .edgesIgnoringSafeArea(.all)
                        .id(weathers.count)
                        
                        
                    } else {
                        LoadingView()
                            .onAppear {
                                Task {
                                    do {
                                        localWeather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                        localCityName = try await cityNameManager.getCurrentCityName(latitude: location.latitude, longitude: location.longitude)
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
            .background(Color.clear)
            .preferredColorScheme(.dark)
            
            if isLoaded {
                
                VStack() {
                    Spacer()
                    
                    HStack() {
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
                            //tabIndex = weathers.count
                            //currentId = weathers.count
                            
                        })) {
                            SearchView(showSearchView: $showSearchView)
                                .presentationBackground(.clear)

                        }
                        
                        Spacer()
                        
                        Button(action: {
                            //showSearchView.toggle()
                            if (tabIndex != -1) {
                                currentId = tabIndex
                                tabIndex = tabIndex - 1
                                //print(currentId)
    
                                //print(cities[currentId])
                                cities.remove(at: currentId)
                                weathers.remove(at: currentId)
                                //print(cities)

                                currentId = currentId - 1
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:50)
                                .foregroundStyle(.white)
                        }
                        
                        Spacer()
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
                localWeather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                localCityName = try await cityNameManager.getCurrentCityName(latitude: location.latitude, longitude: location.longitude)
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
