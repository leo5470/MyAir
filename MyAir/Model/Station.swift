//
//  Station.swift
//  MyAir
//
//  Created by Leo Cheng on 2024/4/14.
//

import Foundation

struct station: Decodable {
    let siteName: String
    let siteEngName: String
    let areaName: String
    let county: String
    let township: String
    let siteAddress: String
    let twd97lon: String
    let twd97lat: String
    let siteType: String
    let siteID: String
    
    enum CodingKeys: String, CodingKey {
        case siteName = "sitename"
        case siteEngName = "siteengname"
        case areaName = "areaname"
        case county
        case township
        case siteAddress = "siteaddress"
        case twd97lon
        case twd97lat
        case siteType = "sitetype"
        case siteID = "siteid"
    }
}
