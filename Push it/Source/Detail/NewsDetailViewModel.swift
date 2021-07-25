//
//  NewsDetailViewModel.swift
//  Push it
//
//  Created by Bart on 03/05/2021.
//

import UIKit
import RxSwift
import RxCocoa

protocol NewsDetailViewModelProtocol {
    
    var stateObservable: Observable<NewsDetailState> { get }
        
    var author: String? { get }
    var content: String? { get }
    var description: String? { get }
    var title: String { get }
    var source: String { get }
    
    func downloadImage()
}

class NewsDetailViewModel: NewsDetailViewModelProtocol {
    
    // Article
    private let article: Article

    var author: String? {
        return article.author
    }
    
    var content: String? {
        return article.content
    }
    
    var description: String? {
        return article.description
    }

    var title: String {
        return article.title
    }

    var source: String {
        return article.sourceName
    }

    // State
    private var stateRelay = BehaviorRelay<NewsDetailState>(value: NewsDetailState(imageState: .loading))
    
    var stateObservable: Observable<NewsDetailState> {
        return stateRelay.asObservable()
    }

    init(article: Article) {
        self.article = article
    }
    
    func downloadImage() {
        
        guard let imageString = article.urlToImage,
              let url = URL(string: imageString) else {
            return
        }
        
        ImageDownloader.downloadImage(forURL: url) { [weak self] result in
            
            switch result {
            case .success(let image):
                self?.stateRelay.accept(NewsDetailState(imageState: .result(image)))
            case .failure(let error):
                self?.stateRelay.accept(NewsDetailState(imageState: .error(error)))
            }
        }
    }
}
