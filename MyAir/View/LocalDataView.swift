//
//  LocalDataView.swift
//  MyAir
//
//  Created by Leo Cheng on 2024/4/15.
//

import SwiftUI

struct LocalDataView: View {
    @State private var showAlert = false
    
    @StateObject private var viewModel: LocalDataViewModel
        
    init(aqi: AQIForSingleLocation) {
        _viewModel = StateObject(wrappedValue: LocalDataViewModel(aqi: aqi))
    }
    
    init(id: String) {
        _viewModel = StateObject(wrappedValue: LocalDataViewModel(id: id))
    }
    
    var body: some View {
        Group {
            if viewModel.aqi == nil {
                LinearGradient(colors: [Color("Dark Grey"), Color("Light Grey")], startPoint: .bottom, endPoint: .top)
                    .ignoresSafeArea(.all)
                    .onAppear {
                        Task {
                            do {
                                try await viewModel.load()
                            } catch {
                                showAlert = true
                            }
                        }
                    }
            }
            else {
                ZStack {
                    LinearGradient(colors: [Color("Dark \(viewModel.gradColor)"), Color("Light \(viewModel.gradColor)")], startPoint: .bottom, endPoint: .top)
                        .ignoresSafeArea(.all)
                    
                    VStack {
                        Text(" \(viewModel.aqi!.siteName) ")
                            .font(.system(size: 40, weight: .medium))
                            .foregroundStyle(.white)
                        
                        Text(" \(viewModel.aqi!.aqi) ")
                            .font(.system(size: 128, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.vertical, -30)
                        
                        Text(" \(viewModel.aqiInEnum.status) ")
                            .font(.system(size: 24))
                            .foregroundStyle(.white)
                        
                        HStack {
                            VStack {
                                Text("PM2.5")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundStyle(.white)
                                
                                Text(" \(viewModel.aqi!.pm2_5) ")
                                    .font(.system(size: 64, weight: .medium))
                                    .foregroundStyle(.white)
                            }
                            .padding(.leading, 50)
                            
                            Spacer()
                            
                            VStack {
                                Text("PM10")
                                    .font(.system(size: 32, weight: .medium))
                                    .foregroundStyle(.white)
                                
                                Text(" \(viewModel.aqi!.pm10) ")
                                    .font(.system(size: 64, weight: .medium))
                                    .foregroundStyle(.white)
                            }
                            .padding(.trailing, 50)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 25.0)
                                .inset(by: 0.5)
                                .foregroundColor(.black.opacity(0.05))
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        
                        VStack() {
                            HStack {
                                Text("SO2 | \(viewModel.aqi!.so2)")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                Text("CO | \(viewModel.aqi!.co)")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal, 30)
                            
                            HStack {
                                Text("O3 | \(viewModel.aqi!.o3)")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                Text("NO2 | \(viewModel.aqi!.no2)")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal, 30)
                            
                            HStack {
                                Text("NOx | \(viewModel.aqi!.nox)")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                Text("NO | \(viewModel.aqi!.no)")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal, 30)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 25.0)
                                .inset(by: 0.5)
                                .foregroundColor(.black.opacity(0.05))
                        )
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        Text("測量時間 | \(viewModel.aqi!.publishTime)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white)
                    }
                    .padding(.top, 20)
                    
                }
            }
        }
        .refreshable {
            Task {
                do {
                    try await viewModel.load()
                } catch {
                    showAlert = true
                }
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
        }
    }
}

#Preview {
    LocalDataView(aqi: AQIForSingleLocation(siteName: "古亭", county: "5", aqi: "67", pollutant: "abc", status: "abc", so2: "50", co: "50", o3: "50", o3_8hr: "abc", pm10: "50", pm2_5: "50", no2: "50", nox: "50", no: "50", windSpeed: "abc", windDirec: "abc", publishTime: "2024/04/19 02:00:00", co_8hr: "abc", pm2_5_avg: "abc", pm10_avg: "abc", so2_avg: "abc", longitude: "abc", latitude: "abc", siteID: "abc"))
}
