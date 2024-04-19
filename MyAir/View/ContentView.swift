//
//  ContentView.swift
//  MyAir
//
//  Created by Leo Cheng on 2024/4/13.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var isLocalDataViewActive = false
    @State private var isOtherStationViewActive = false
    @State private var showAlert = false
    
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("MyAir")
                    .font(.system(size: 40, weight: .bold))
                    .padding(.leading, 15)
                    .padding(.top, 30)
                    .onAppear {
                        Task {
                            do {
                                try await viewModel.load()
                            } catch {
                                showAlert = true
                            }
                        }
                    }
                
                
                if viewModel.closestAQI == nil {
                    LocalAQIComponentView(stationName: "", aqiValue: "-1")
                        .padding(.horizontal, 15)
                } else {
                    NavigationLink(value: viewModel.closestAQI!) {
                        LocalAQIComponentView(stationName: viewModel.closestStation!.siteName, aqiValue: viewModel.closestAQI!.aqi)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
                            .shadow(color: .black.opacity(0.1), radius: 1.5, x: 0, y: 0)
                        .padding(.horizontal, 15)
                    }
                }
                    
                if viewModel.stations == nil {
                    SmallComponentView(caption: "其他\n測站資料", symbolName: "map.fill", isNil: true)
                        .padding(.horizontal, 15)
                } else {
                    NavigationLink(value: viewModel.stations!) {
                        SmallComponentView(caption: "其他\n測站資料", symbolName: "map.fill", isNil: false)
                            .padding(.horizontal, 15)
                            .shadow(color: .black.opacity(0.4), radius: 2, x: 0, y: 2)
                        .shadow(color: .black.opacity(0.1), radius: 1.5, x: 0, y: 0)
                    }
                }
                
                // Map() can directly be called in iOS 17+ only
                if viewModel.closestAQI == nil {
                    Map()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 15)
                        .padding(.bottom, 15)
                } else {
                    Map{
                        UserAnnotation()
                        
                        Marker(viewModel.closestStation!.siteName, coordinate: viewModel.closestStationCoordinate!)
                    }
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 15)
                        .padding(.bottom, 15)
                }
            }
            .alert("無法獲取資料，請稍後再試", isPresented: $showAlert)
            {
                Button("重新整理") {
                    showAlert = false
                    Task {
                        do {
                            try await viewModel.load()
                        } catch {
                            showAlert = true
                        }
                    }
                }
            } message: {
                Text("若網路正常，您仍可查看其他測站資料")
            }
            
            Spacer()
                .navigationDestination(for: AQIForSingleLocation.self) { 
                    aqi in LocalDataView(aqi: aqi)
                }
                .navigationDestination(for: [Station].self) {
                    stations in OtherStationView(stations: stations)
                }
                .navigationDestination(for: Station.self) {
                    station in LocalDataView(id: station.siteID)
                }
        }
    }
}

#Preview {
    ContentView()
}
