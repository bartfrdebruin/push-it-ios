//
//  Article.swift
//  Push it
//
//  Created by Bart on 03/04/2021.
//

import Foundation

struct Article: Decodable {
    
    let source: Source
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
    
    struct Source: Decodable {
        let id: String?
        let name: String
    }
}
