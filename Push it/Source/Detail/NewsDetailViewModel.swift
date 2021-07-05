//
//  NewsDetailViewModel.swift
//  Push it
//
//  Created by Bart on 03/05/2021.
//

import UIKit
import RxSwift
import RxCocoa

class NewsDetailViewModel {
    
    // Article
    private var article: Article
    private var articleImage: UIImage?
    
    // State
    private var stateRelay = BehaviorRelay<State>(value: .loading)
    
    var stateObservable: Observable<State> {
        return stateRelay.asObservable()
    }

    init(article: Article) {
        self.article = article
    }
    
    func getArticle() {
        downloadImage()
    }
    
    func image() -> UIImage? {
        return articleImage
    }
    
    func author() -> String? {
        return article.author
    }
    
    func content() -> String? {
        return article.content
    }

    func description() -> String? {
        return article.description
    }
    
    func title() -> String {
        return article.title
    }
    
    func source() -> String {
        return article.source.name
    }
}

// MARK: - ImageDownLoader
extension NewsDetailViewModel {
    
    private func downloadImage() {
        
        guard let imageString = article.urlToImage,
              let url = URL(string: imageString) else {
            return
        }
        
        ImageDownloader.downloadImage(forURL: url) { [weak self] result in
            
            switch result {
            case .success(let image):
                self?.articleImage = image
                self?.stateRelay.accept(.result)
            case .failure(let error):
                self?.stateRelay.accept(.error(error))
            }
        }
    }
}
