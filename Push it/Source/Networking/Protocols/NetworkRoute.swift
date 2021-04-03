//
//  NetworkRoute.swift
//  PlantFinder
//
//  Created by Bart de Bruin on 23/01/2020.
//  Copyright © 2020 Bart de Bruin. All rights reserved.
//

import Foundation
import UIKit

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

protocol NetworkRoute {
    var path: String { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var queryParameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

extension NetworkRoute {
    
    var method: HTTPMethod {
        return .GET
    }
    
    var body: Data? {
        return nil
    }
    
    var queryParameters: [String: Any]? {
        return nil
    }
    
    var headers: [String: String]? {
        return nil
    }
}

extension NetworkRoute {
    
    /**
    Create a URLRequest based on a route
    */
    func createURLRequest(withEnvironment environment: NetworkEnvironment) throws -> URLRequest {
        
        // Make we have a valid base URL
        guard var components = URLComponents(string: environment.baseURL.absoluteString + path) else {
            throw NetworkError.invalidRequest
        }
        
        // Add the query parameters
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            
            var parameters: [String: Any] = [:]
            
            queryParameters.forEach { tuple in
                parameters [tuple.key] = tuple.value
            }
            
            let queryItems = parameters.compactMap({ (key, value) -> URLQueryItem in
                return URLQueryItem(name: key, value: "\(value)")
            })
            
            components.queryItems = queryItems
        }
        
        // Make sure we still have a valid URL
        guard let url = components.url else {
            throw NetworkError.invalidRequest
        }
        
        // Create the request
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        // Add headers
        if let headers = environment.headers, !headers.isEmpty {
            
            for header in headers.enumerated() {
                
                request.setValue(header.element.value, forHTTPHeaderField: header.element.key)
            }
        }
        
        // Add specific route headers
        if let headers = headers, !headers.isEmpty {
            
            for header in headers.enumerated() {
                request.setValue(header.element.value, forHTTPHeaderField: header.element.key)
            }
        }
        
        return request
    }
}
