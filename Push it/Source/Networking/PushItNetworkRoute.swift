//
//  PushItNetworkRoute.swift
//  Push it
//
//  Created by Bart on 03/04/2021.
//

import Foundation

enum PushItNetworkRoute {
    case headlines
    case sports
    case foreign
    case domestic
}

extension PushItNetworkRoute: NetworkRoute {
    
    var method: HTTPMethod {
        switch self {
        case .headlines, .domestic, .foreign, .sports:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .headlines:
            return "/top-headlines?country=nl&apiKey=\(Configuration.APIKey)"
        case .domestic:
            return "/everything?q=news&language=nl&\(components())"
        case .foreign:
            return "/everything?q=buitenland&language=nl&\(components())"
        case .sports:
            return "/everything?q=sports&language=nl&\(components())"
        }
    }
    
    var body: Data? {
        switch self {
        case .headlines, .domestic, .foreign, .sports:
            return nil
        }
    }
}

// MARK: - Helper
extension PushItNetworkRoute {
    
    private func components() -> String {
        return "from=\(Date().twentyDaysAgo())&to=\(Date().today())&sortBy=popularity&apiKey=\(Configuration.APIKey)"
    }
}





