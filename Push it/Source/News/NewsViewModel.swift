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
    private(set) var articles: [Article] = []

    private(set) var state: State = .initial {
        didSet {
            refreshState()
        }
    }
    
    var refreshState: () -> Void = {}
    
    func getNews() {
        
        networkLayer.allNews().sink { (error) in

            switch error {
            case .failure(let error):
                self.state = .error(error)
            default:
                break
            }
            
        } receiveValue: { (news) in
            
            self.articles = news.articles
            self.state = .result
            
            print("news", news)
            
        }.store(in: &disposables)
    }
    
    func numberOfArticles() -> Int {
        
        return articles.count
    }
    
    func article(at indexPath: IndexPath) -> Article? {
        
        guard indexPath.item < articles.count else {
            return nil
        }
        
        return articles[indexPath.item]
    }
}
