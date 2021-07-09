//
//  NewsDetailPresenter.swift
//  Push it
//
//  Created by Bart on 09/07/2021.
//

import UIKit

class NewsDetailPresenter {
    
    // View
    weak var view: NewsDetailViewController!
    
    // Article
    private let article: Article
    
    init(article: Article) {
        self.article = article
    }
    
    func viewDidLoad() {
        
        downloadImage()
        view.configureLabels(with: article)
    }
}

// MARK: - ImageDownLoader
extension NewsDetailPresenter {
    
    func downloadImage() {
        
        guard let imageString = article.urlToImage,
              let url = URL(string: imageString) else {
            return
        }
        
        ImageDownloader.downloadImage(forURL: url) { [weak self] result in
            
            switch result {
            case .success(let image):
                self?.view.configureImage(with: image)
            case .failure(let error):
                print("Error", error)
            }
        }
    }
}

// MARK: - Factory
extension NewsDetailPresenter {
    
    static func make(with article: Article) -> NewsDetailPresenter {
 
        let presenter = NewsDetailPresenter(article: article)
        let storyboard = UIStoryboard(name: "NewsDetailViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "NewsDetailViewController", creator: { coder in
                return NewsDetailViewController(coder: coder, presenter: presenter)
            })
        
        presenter.view = vc
        return presenter
    }
}
