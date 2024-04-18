//
//  LocalAQIComponentView.swift
//  MyAir
//
//  This SwiftUI view is designed to provide a fast peek on
//  the local AQI value for the user.
//
//  Created by Leo Cheng on 2024/4/14.
//

import SwiftUI

struct LocalAQIComponentView: View {
    var stationName: String
    var aqiValue: String
    var aqiInInt: Int
    var aqiInEnum: AQI
    var gradColor: String
    
    init(stationName: String, aqiValue: String) {
        self.stationName = stationName
        self.aqiValue = aqiValue
        self.aqiInInt = Int(aqiValue) ?? -1
        self.aqiInEnum = AQI.getAQI(value: aqiInInt)
        self.gradColor = aqiInEnum.color
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("Dark \(gradColor)"), Color("Light \(gradColor)")], startPoint: .bottom, endPoint: .top)
            
            HStack {
                VStack(alignment: .leading) {
                    Spacer()
                    Text("最近測站")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white)
                    
                    Text("\(stationName)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                }
                .padding(.bottom, 30)
                
                Spacer()
                
                // Empty if no data available
                if(aqiInInt != -1) {
                    VStack(alignment: .leading, spacing: -30) {
                        Text(" AQI")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white)
                        
                        Text("\(aqiValue)")
                            .font(.system(size: 128, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.top, 0)
                    }
                    .padding(.bottom, -25)
                }
            }
            .padding(.horizontal, 15)
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .frame(height: 170)
        .clipShape(RoundedRectangle(cornerRadius: 20.0))
        .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
        .shadow(color: .black.opacity(0.1), radius: 1.5, x: 0, y: 0)
    }
}

#Preview {
    LocalAQIComponentView(stationName: "中正站", aqiValue: "")
}
