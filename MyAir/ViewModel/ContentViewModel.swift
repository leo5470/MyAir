//
//  ContentViewModel.swift
//  MyAir
//
//  Created by Leo Cheng on 2024/4/15.
//

import Foundation
import CoreLocation


class ContentViewModel: ObservableObject {
    // Consider performing secret management here.
    let MOENVApiKey = "7d1cba85-cbee-42b1-903a-4ec9624ee571"
    let location = Location()
    
    @Published var userLocation: CLLocation? = nil
    @Published var stations: [Station]? = nil
    @Published var closestStation: Station? = nil
    @Published var closestStationCoordinate: CLLocationCoordinate2D? = nil
    @Published var closestAQI: AQIForSingleLocation? = nil
    
    func load() async throws{
        // Publishing changes from background threads is not allowed;
        // make sure to publish values from the main thread (via operators like receive(on:)) on model updates.
        do {
            
            let fetchedStations = try await fetchStations()
            
            await MainActor.run {
                stations = fetchedStations
            }
            
            let fetchedUserLocation = try location.requestCurrentLocation()
            await MainActor.run {
                userLocation = fetchedUserLocation
            }
            
            let fetchedClosestStation = try await findClosestStation()
            await MainActor.run {
                closestStation = fetchedClosestStation
            }
            
            let fetchedCoordinate = try getClosestStationCoordinate()
            
            // Force unwrap since if station cannot be found, the error would be caught first
            let fetchedClosestAQI = try await fetchAQI(siteID: closestStation!.siteID)
            await MainActor.run {
                closestStationCoordinate = fetchedCoordinate
                closestAQI = fetchedClosestAQI
            }
            
            // Debug
            print("Userdata loaded")
            print("Lat: \(userLocation!.coordinate.latitude), Lon: \(userLocation!.coordinate.longitude)")
            print("Station: \(closestStation!.siteName)")
            print("AQI: \(closestAQI!.aqi)")
        } catch {
            print("Error occurred while trying to initialize ContentViewModel: \(String(describing: error))")
            throw error
        }
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
        if stations == nil || stations!.count == 0 {
            throw APIError.NoDataError
        }
        
        var closestStation: Station = stations![0]
        var closestDistance: Double = Double.greatestFiniteMagnitude
        for station in stations! {
            if station == stations![0] {
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
    
    func getClosestStationCoordinate() throws -> CLLocationCoordinate2D {
        if closestStation == nil {
            throw APIError.NILError
        }
        
        let longitude = closestStation!.longitude
        let latitude = closestStation!.latitude
        
        guard let longitudeDouble: Double = Double(longitude) else {
            print("Unable to convert longtitude in Station to double.")
            throw APIError.ConvertError
        }
        
        guard let latitudeDouble = Double(latitude) else {
            print("Unable to convert latitude in Station to double.")
            throw APIError.ConvertError
        }
        
        let coord = CLLocationCoordinate2D(latitude: latitudeDouble, longitude: longitudeDouble)
        return coord
    }
}
