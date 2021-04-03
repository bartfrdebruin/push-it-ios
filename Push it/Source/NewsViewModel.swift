//
//  NewsViewModel.swift
//  Push it
//
//  Created by Bart on 03/04/2021.
//

import Foundation
import Combine

enum State {
    case initial
    case loading
    case result
    case error(Error)
}

class NewsViewModel {
    
    private let networkLayer = PushItNetworkLayer()
    private var disposables = Set<AnyCancellable>()
    private var articles: [Article] = []

    private(set) var state: State = .initial {
        didSet {
            refreshState()
        }
    }
    
    var refreshState: () -> Void = {}
    
    func getNews() {
        
        networkLayer.allNews().sink { (error) in
            
            print("error", error)
            
        } receiveValue: { (news) in
            
            print("news", news)
            
        }.store(in: &disposables)
    }
    
    func article(at indexPath: IndexPath) -> Article? {
        
        guard indexPath.item < articles.count else {
            return nil
        }
        
        return articles[indexPath.item]
    }
}
