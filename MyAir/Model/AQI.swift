//
//  AirInfo.swift
//  MyAir
//
//  A model file that stores necessary info about AQI (Air Quality Index).
//
//  Created by Leo Cheng on 2024/4/13.
//

import Foundation

enum AQI: Int {
    case unavailable
    case good
    case moderate
    case unhealthyForSensitiveGroups
    case unhealthy
    case veryUnhealthy
    case hazardous
    
    var status: String{
        switch self {
        case .good:
            return "良好"
        case .moderate:
            return "普通"
        case .unhealthyForSensitiveGroups:
            return "對敏感族群不健康"
        case .unhealthy:
            return "對所有族群不健康"
        case .veryUnhealthy:
            return "非常不健康"
        case .hazardous:
            return "危害"
        default:
            return "無資料"
        }
    }
    
    var range: String {
        switch self {
        case .good:
            return "0至50"
        case .moderate:
            return "51至100"
        case .unhealthyForSensitiveGroups:
            return "101至150"
        case .unhealthy:
            return "151至200"
        case .veryUnhealthy:
            return "201至300"
        case .hazardous:
            return "301以上"
        default:
            return "無資料"
        }
    }
    
    var color: String {
        switch self {
        case .good:
            return "Green"
        case .moderate:
            return "Yellow"
        case .unhealthyForSensitiveGroups:
            return "Orange"
        case .unhealthy:
            return "Red"
        case .veryUnhealthy:
            return "Purple"
        case .hazardous:
            return "Maroon"
        default:
            return "Grey"
        }
    }
    
    static func getAQI(value: Int) -> AQI {
        switch value {
        case 0...50:
            return .good
        case 51...100:
            return .moderate
        case 101...150:
            return .unhealthyForSensitiveGroups
        case 151...200:
            return .unhealthy
        case 201...300:
            return .veryUnhealthy
        case _ where value >= 301:
            return .hazardous
        default:
            return .unavailable
        }
    }
}

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



