//
//  Station.swift
//  MyAir
//
//  Created by Leo Cheng on 2024/4/14.
//

import Foundation

struct Station: Decodable, Equatable, Hashable {
    let siteName: String
    let siteEngName: String
    let areaName: String
    let county: String
    let township: String
    let siteAddress: String
    let longitude: String
    let latitude: String
    let siteType: String
    let siteID: String
    
    enum CodingKeys: String, CodingKey { // Map JSON names into the Struct
        case siteName = "sitename"
        case siteEngName = "siteengname"
        case areaName = "areaname"
        case county
        case township
        case siteAddress = "siteaddress"
        // Note that TWD97 is in fact very close to WGS84, so no further action will be performed
        case longitude = "twd97lon"
        case latitude = "twd97lat"
        case siteType = "sitetype"
        case siteID = "siteid"
    }
}

extension Station: Identifiable {
    var id: String { siteID }
}

struct Stations: Decodable {
    let records: [Station] // records is the name of array given in JSON
}
