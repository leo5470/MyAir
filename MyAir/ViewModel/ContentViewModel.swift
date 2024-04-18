//
//  ContentViewModel.swift
//  MyAir
//
//  Created by Leo Cheng on 2024/4/15.
//

import Foundation
import CoreLocation

import SwiftLocation

class ContentViewModel: ObservableObject {
    let MOENVApiKey = ProcessInfo.processInfo.environment["MOENV_API_KEY"] ?? ""
    
    @Published var userLocation: CLLocation? = nil
    @Published var stations: [Station]? = nil
    @Published var closestStation: Station? = nil
    @Published var closestAQI: AQIForSingleLocation? = nil
    
    func load() async throws{
        do {
            userLocation = try await getUserLocation()
            closestStation = try await findClosestStation()
            // Force unwrap since if station cannot be found, the error would be caught first
            closestAQI = try await fetchAQI(siteID: closestStation!.siteID)
        } catch {
            print("Error occurred while trying to initialize ContentViewModel: \(error)")
        }
    }
    
    func getUserLocation() async throws -> CLLocation? {
        let location = Location()
        var currentLocation: CLLocation?
        do {
            // SwiftLocation
            try await location.requestPermission(.whenInUse) // obtain the permissions
            currentLocation = try await location.requestLocation().location // get the location
        } catch {
            print("Error occurred while trying to obtain location: \(error)")
            throw APIError.LocationError
        }
        return currentLocation
    }
    
    
    func fetchAQI(siteID: String) async throws -> AQIForSingleLocation {
        guard let url = URL(string: "https://data.moenv.gov.tw/api/v2/aqx_p_432?api_key=\(MOENVApiKey)") else {
            print("Invalid URL")
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let responseData = try JSONDecoder().decode(AQIForMultipleLocations.self, from: data)
        guard let target = responseData.records.first(where: {$0.siteID == siteID}) else {
            throw APIError.NoDataError
        }
        return target
    }
    
    func fetchStations() async throws -> [Station] {
        guard let url = URL(string: "https://data.moenv.gov.tw/api/v2/aqx_p_07?api_key=\(MOENVApiKey)") else {
            print("URL in fetchStations() is invalid")
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let responseData = try JSONDecoder().decode(Stations.self, from: data)
        return responseData.records
    }
    
    func findClosestStation() async throws -> Station {
        // Would be caught during init(), but still handle here.
        if userLocation == nil {
            throw APIError.LocationError
        }
        
        let stations: [Station] = try await fetchStations()
        var closestStation: Station = stations[0]
        var closestDistance: Double = Double.greatestFiniteMagnitude
        for station in stations {
            if station == stations[0] {
                continue
            }
            let longitude = station.longitude
            let latitude = station.latitude
            
            guard let longitudeDouble: Double = Double(longitude) else {
                print("Unable to convert longtitude in Station to double.")
                throw APIError.ConvertError
            }
            
            guard let latitudeDouble = Double(latitude) else {
                print("Unable to convert latitude in Station to double.")
                throw APIError.ConvertError
            }
            
            let stationLocation = CLLocation(latitude: latitudeDouble, longitude: longitudeDouble)
            
            let currentDistance = userLocation!.distance(from: stationLocation)
            if currentDistance < closestDistance {
                closestStation = station
                closestDistance = currentDistance
            }
        }
        return closestStation
    }
}
