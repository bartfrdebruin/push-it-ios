//
//  PushItNetworkEnvironment.swift
//  Push it
//
//  Created by Bart on 03/04/2021.
//

import Foundation

class PushItNetworkEnvironment: NetworkEnvironment {
  
    var baseURL: URL {
        return URL(string: "https://newsapi.org/v2/")!
    }
    
    var headers: [String : String]? {
        return ["apiKey": Configuration.APIKey]
    }
}
