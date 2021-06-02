//
//  NewsDetailViewModel.swift
//  Push it
//
//  Created by Bart on 03/05/2021.
//

import Foundation
import RxSwift
import RxRelay

class NewsDetailViewModel {
    
    private let relayURL = BehaviorSubject<URL?>(value: nil)
    
    var article: Article
    var observableURL: Observable<URL?> {
        return relayURL.asObservable()
    }
    
    init(article: Article) {
        self.article = article
        
        relayURL.on(.next(URL(string: article.url)!))
        
        
    }
}
