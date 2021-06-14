//
//  NetworkTask.swift
//  PlantFinder
//
//  Created by Bart de Bruin on 23/01/2020.
//  Copyright © 2020 Bart de Bruin. All rights reserved.
//

import Foundation

protocol NetworkTask {

    func resume()
    func suspend()
    func cancel()
}

class URLSessionNetworkTask: NetworkTask {
    
    let task: URLSessionTask
    
    init(task: URLSessionTask) {
        self.task = task
    }
    
    func resume() {
        task.resume()
    }
    
    func suspend() {
        task.suspend()
    }
    
    func cancel() {
        task.cancel()
    }
}
