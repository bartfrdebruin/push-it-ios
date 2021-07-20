//
//  NewsDetailViewModel.swift
//  Push it
//
//  Created by Bart on 03/05/2021.
//

import UIKit
import RxSwift
import RxCocoa

enum ImageState {
    case loading
    case result
    case error(Error)
}

protocol NewsDetailViewModelProtocol {
    
    var imageStateObservable: Observable<ImageState> { get }
        
    var author: String? { get }
    var content: String? { get }
    var description: String? { get }
    var title: String { get }
    var source: String { get }
    var image: UIImage? { get }
    
    func downloadImage()
}

class NewsDetailViewModel: NewsDetailViewModelProtocol {
    
    // Article
    private let article: Article
    
    var image: UIImage?

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
        return article.source.name
    }

    // State
    private var stateRelay = BehaviorRelay<ImageState>(value: .loading)
    
    var imageStateObservable: Observable<ImageState> {
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
                self?.image = image
                self?.stateRelay.accept(.result)
            case .failure(let error):
                self?.stateRelay.accept(.error(error))
            }
        }
    }
}
