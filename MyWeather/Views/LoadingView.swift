//
//  LoadingView.swift
//  MyWeather
//
//  Created by 张梓欣 on 9/3/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack(alignment: .center) {
            
            Image("LoadingBg")
                .resizable()
                //.frame(width: 100, height: 100)
                //.aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                //.aspectRatio(contentMode: .fill)

            VStack(spacing: 20) {
                Spacer()
                Image("logo")
                    .resizable()
                    .frame(width: 120, height: 120)
                Text("MyWeather")
                    .font(.largeTitle)
            }
            .padding(50)



            
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(red:0.4, green:0.4, blue:0.4))
        .preferredColorScheme(.dark)    }
}

#Preview {
    LoadingView()
}
