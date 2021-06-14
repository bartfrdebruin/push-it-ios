//
//  NetworkEnvironment.swift
//  PlantFinder
//
//  Created by Bart de Bruin on 22/01/2020.
//  Copyright © 2020 Bart de Bruin. All rights reserved.
//

import Foundation

protocol NetworkEnvironment {
    
    var baseURL: URL { get }
    var headers: [String: String]? { get }
}

