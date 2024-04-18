//
//  APIError.swift
//  MyAir
//
//  Created by Leo Cheng on 2024/4/18.
//

import Foundation

enum APIError: Error {
    case ConvertError // Handle general failed conversions
    case LocationError // Handle general Location-related errors
    case NoDataError // Handle general no-data errors
}
