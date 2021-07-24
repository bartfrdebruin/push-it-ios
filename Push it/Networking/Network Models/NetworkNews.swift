//
//  News.swift
//  Push it
//
//  Created by Bart on 03/04/2021.
//

import Foundation

struct NetworkNews: Decodable {
    let status: String
    let totalResults: Int
    let articles: [NetworkArticle]
}

