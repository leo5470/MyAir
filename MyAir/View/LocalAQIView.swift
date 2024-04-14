//
//  LocalAQIView.swift
//  MyAir
//
//  This SwiftUI view is designed to provide a fast peek on
//  the local AQI value for the user.
//
//  Created by Leo Cheng on 2024/4/14.
//

import SwiftUI

struct LocalAQIView: View {
    var stationName: String
    var aqiValue: String
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.accent, Color("Light Blue")], startPoint: .bottom, endPoint: .top)
            
            HStack {
                VStack(alignment: .leading) {
                    Spacer()
                    Text("最近測站")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white)
                    
                    Text("\(stationName)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.bottom, 40)
                }
                .padding(.leading, 15)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: -30) {
                    Text(" AQI")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                    
                    Text("\(aqiValue)")
                        .font(.system(size: 128, weight: .medium))
                        .foregroundStyle(.white)
                        .padding(.top, 0)
                        .padding(.bottom, -10)
                }
                .padding(.trailing, 15)
            }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .frame(height: 170)
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        .padding(.horizontal, 15)
    }
}

#Preview {
    LocalAQIView(stationName: "中正站", aqiValue: "100")
}
