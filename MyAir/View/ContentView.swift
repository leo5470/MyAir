//
//  ContentView.swift
//  MyAir
//
//  Created by Leo Cheng on 2024/4/13.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("MyAir")
                .font(.system(size: 40, weight: .bold))
                .padding(.leading, 15)
                .padding(.top, 30)
            
            LocalAQIComponentView(stationName: "中正站", aqiValue: "58")
                .padding(.horizontal, 15)
            
            HStack {
                SmallComponentView(caption: "更多\n本地資料", symbolName: "mappin")
                    .padding(.leading,  15)
                
                SmallComponentView(caption: "其他\n測站資料", symbolName: "map.fill")
                    .padding(.trailing, 15)
            }
            
            // Map() can directly be called in iOS 17+ only
            Map()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 15)
                .padding(.bottom, 15)
        }
    }
}

#Preview {
    ContentView()
}
