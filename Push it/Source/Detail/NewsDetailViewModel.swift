//
//  NewsDetailViewModel.swift
//  Push it
//
//  Created by Bart on 03/05/2021.
//

import Foundation
import  UIKit

class NewsDetailViewModel {
    
    private var article: Article
    private var articleImage: UIImage?
    
    private(set) var state: State = .initial {
        didSet {
            refreshState()
        }
    }
    
    var refreshState: () -> Void = {}

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
                self?.state = .result
            case .failure(let error):
                print("Error", error)
            }
        }
    }
}
