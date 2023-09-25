//
//  SearchView.swift
//  MyWeather
//
//  Created by 张梓欣 on 9/23/23.
//

import SwiftUI


struct SearchView: View {
    @State var cityName = ""

    var body: some View {
        VStack(alignment: .center) {
            //Spacer()
            TextField("Enter city name to search", text: $cityName)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.ultraThinMaterial)
        .foregroundColor(.white)

    }
    
}

#Preview {
    SearchView()
}
