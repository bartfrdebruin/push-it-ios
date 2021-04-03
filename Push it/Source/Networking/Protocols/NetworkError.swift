//
//  NetworkError.swift
//  PlantFinder
//
//  Created by Bart de Bruin on 23/01/2020.
//  Copyright © 2020 Bart de Bruin. All rights reserved.
//

import Foundation

struct NetworkStatusError {
    let code: Int
    let data: Data?
}

enum NetworkError: LocalizedError {
    case unexpectedStatus(NetworkStatusError)
    case invalidRequest
    case mappingError(Error)
    case unknownError(Error)
}

// MARK: - Localisation
extension NetworkError {

    var errorDescription: String? {
        switch self {
        case .mappingError(let error), .unknownError(let error):
            return error.localizedDescription
        default:
            return nil
        }
    }
}
