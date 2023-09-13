//
//  WeatherRow.swift
//  MyWeather
//
//  Created by 张梓欣 on 9/13/23.
//

import SwiftUI

struct WeatherRow: View {
    var logo: String
    var name: String
    var value: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: logo)
                .font(.title3)
                .frame(width: 10, height: 10)
                .padding()
                .foregroundColor(.black)

                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                .cornerRadius(50)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .font(.subheadline)
                
                Text(value)
                    .bold()
                    .font(.title3)
            }
            .frame(width: 75, alignment: .leading)
            //.background(.red)

        }
    }
}

struct WeatherRow_Previews: PreviewProvider {
    static var previews: some View {
        WeatherRow(logo: "thermometer", name: "Temp", value: "8°")
    }
}
