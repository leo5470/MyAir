//
//  ContentView.swift
//  MyAir
//
//  Created by Leo Cheng on 2024/4/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("MyAir")
                .font(.system(size: 40, weight: .bold))
                .padding(.leading, 10)
            
            LocalAQIView(stationName: "中正站", aqiValue: "58")
        }
    }
}

#Preview {
    ContentView()
}
