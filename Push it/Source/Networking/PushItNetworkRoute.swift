//
//  PushItNetworkRoute.swift
//  Push it
//
//  Created by Bart on 03/04/2021.
//

import Foundation

enum PushItNetworkRoute {
    case topHeadlines
    case everything
}

extension PushItNetworkRoute: NetworkRoute {
    
    var method: HTTPMethod {
        switch self {
        case .topHeadlines, .everything:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .topHeadlines:
            return "/top-headlines"
        case .everything:
            return "/everything?q=apple&from=2021-04-02&to=2021-04-02&sortBy=popularity&apiKey=\(Configuration.APIKey)"
        }
    }
    
    var body: Data? {
        switch self {
        case .topHeadlines:
            return nil
        case .everything:
            return nil
        }
    }
}




