//
//  NetworkResponse.swift
//  Push it
//
//  Created by Bart on 24/05/2021.
//

import Foundation

struct NetworkResponse {

    public let request: URLRequest
    public let response: HTTPURLResponse
    public let data: Data?
}
