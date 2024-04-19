//
//  OtherStationView.swift
//  MyAir
//
//  Created by Leo Cheng on 2024/4/15.
//

import SwiftUI

struct OtherStationView: View {
    var stations: [Station]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("其他測站")
                .font(.system(size: 40, weight: .bold))
                .padding(.top, 15)
                .padding(.leading, 15)
            
            List {
                ForEach(stations) {
                    station in
                    NavigationLink(value: station) {
                        Text("\(station.siteName)")
                    }
                }
            }
        }
    }
}

//#Preview {
//    OtherStationView()
//}

