//
//  AQIUtil.swift
//  MyAir
//
//  Created by Leo Cheng on 2024/4/19.
//

import Foundation

func fetchAQI(siteID: String) async throws -> AQIForSingleLocation {
    guard let url = URL(string: "https://data.moenv.gov.tw/api/v2/aqx_p_432?api_key=7d1cba85-cbee-42b1-903a-4ec9624ee571") else {
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
