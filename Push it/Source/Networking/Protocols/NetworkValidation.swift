//
//  NetworkValidation.swift
//  PlantFinder
//
//  Created by Bart de Bruin on 23/01/2020.
//  Copyright © 2020 Bart de Bruin. All rights reserved.
//

import Foundation

extension URLResponse {
    
    /**
    Acceptable status codes
    */
    private var acceptableStatusCodes: [Int] {
        return Array(200..<300)
    }
    
    func validate() -> Bool {
        let statusCode = getStatusCode()
        return acceptableStatusCodes.contains(statusCode)
    }
    
    func getStatusCode() -> Int {
        return (self as? HTTPURLResponse)?.statusCode ?? 200
    }
}
