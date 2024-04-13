//
//  AirInfo.swift
//  MyAir
//
//  Created by Leo Cheng on 2024/4/13.
//

import Foundation

struct AQIForSingleLocation: Decodable {
    let siteName: String
    let county: String
    let aqi: String
    let pollutant: String
    let status: String
    let so2: String
    let co: String
    let o3: String
    let o3_8hr: String
    let pm10: String
    let pm2_5: String
    let no2: String
    let nox: String
    let no: String
    let windSpeed: String
    let windDirec: String
    let publishTime: String
    let co_8hr: String
    let pm2_5_avg: String
    let pm10_avg: String
    let so2_avg: String
    let longitude: String
    let latitude: String
    let siteID: String
    
    enum CodingKeys: String, CodingKey {
        case siteName = "sitename"
        case county
        case aqi
        case pollutant
        case status
        case so2
        case co
        case o3
        case o3_8hr
        case pm10
        case pm2_5 = "pm2.5"
        case no2
        case nox
        case no
        case windSpeed = "wind_speed"
        case windDirec = "wind_direc"
        case publishTime = "publishtime"
        case co_8hr
        case pm2_5_avg = "pm2.5_avg"
        case pm10_avg
        case so2_avg
        case longitude
        case latitude
        case siteID = "siteid"
    }
}



