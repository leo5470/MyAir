//
//  LocalViewModel.swift
//  MyAir
//
//  Created by Leo Cheng on 2024/4/19.
//

import Foundation

class LocalDataViewModel: ObservableObject {
    @Published var aqi: AQIForSingleLocation? = nil
    @Published var id: String
    @Published var aqiInEnum: AQI = .unavailable
    @Published var gradColor: String = AQI.getAQI(value: -1).color // Workaround
    
    init(aqi: AQIForSingleLocation) {
        self.aqi = aqi
        id = aqi.siteID
        aqiInEnum = AQI.getAQI(value: Int(aqi.aqi) ?? -1)
        gradColor = aqiInEnum.color
        
    }
    
    init(id: String) {
        self.id = id
    }
    
    func load() async throws {
        do {
            let fetchedAQI = try await fetchAQI(siteID: id)
            await MainActor.run {
                aqi = fetchedAQI
                aqiInEnum = AQI.getAQI(value: Int(aqi!.aqi) ?? -1)
                gradColor = aqiInEnum.color
            }
            
        } catch {
            print("Error occurred while trying to initialize LocalViewModel: \(String(describing: error))")
            throw error
        }
    }
}
