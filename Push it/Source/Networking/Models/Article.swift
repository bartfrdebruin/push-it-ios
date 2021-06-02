//
//  Article.swift
//  Push it
//
//  Created by Bart on 03/04/2021.
//

import Foundation

struct Article: Decodable, Hashable {
    
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
    struct Source: Decodable {
        let id: String?
        let name: String
    }
    
    @ID var id: UUID
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.id == rhs.id
    }
}

@propertyWrapper
struct ID: Hashable {
    var wrappedValue = UUID()
}

extension ID: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(UUID.self)
    }
}

extension KeyedDecodingContainer {
    func decode(_ type: ID.Type,
                forKey key: Key) throws -> ID {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}
