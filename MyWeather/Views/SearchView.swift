//
//  SearchView.swift
//  MyWeather
//
//  Created by 张梓欣 on 9/23/23.
//

import SwiftUI


struct SearchView: View {
    @State var cityName = ""
    
    let names = ["Holly", "Josh", "Rhonda", "Ted","Ada", "Turing", "Ampere", "Renxun","Vega", "RTX", "Honda", "Toyota", "Lovelace", "BMW", "Intel", "Nvidia", "AMD", "RDNA", "Ray", "Gigabyte", "MSI", "Asrock", "Asus"]


    var body: some View {
        NavigationStack {
            //Spacer()
            List {
                ForEach(searchResults, id: \.self.name) { city in
                    NavigationLink {
                        Text("\(city.name), \(city.country)")
                    } label: {
                        Text("\(city.name), \(city.country)")
                    }
                }
            }
            .navigationTitle("Add New Cities")
            .padding()
            
            //Spacer()
        }
        .searchable(text: $cityName, prompt: "Enter city name to search")
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.ultraThinMaterial)
        .foregroundColor(.white)

    }
    
    var searchResults: [City] {
        if cityName.isEmpty {
            return []
        } else {
            let res = cityList.filter {
                $0.name.lowercased().hasPrefix(cityName.lowercased())
            }
            return Array(res[0..<min(20, res.count)])
        }
    }
    
}

#Preview {
    SearchView()
}