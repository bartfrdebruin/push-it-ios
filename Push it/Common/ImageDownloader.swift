//
//  ImageDownloader.swift
//  Push it
//
//  Created by Bart on 09/04/2021.
//

import Foundation
import UIKit

enum DownloadError: Error {
    case general
    case emptyData
    case invalidImage
}

final class ImageDownloader {
    
    @discardableResult
    public static func downloadImage(forURL url: URL,
                                     completion: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionDataTask {
    
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(DownloadError.emptyData))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(DownloadError.invalidImage))
                return
            }
            
            completion(.success(image))
        }
        
        task.resume()
        return task
    }
}
