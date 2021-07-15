//
//  NewsDetailPresenter.swift
//  Push it
//
//  Created by Bart on 09/07/2021.
//

import UIKit

protocol NewsDetailPresenterProtocol {
    
    var view: NewsDetailViewProtocol? { get set }

    func downloadImage()
    func configureLabels()
}

class NewsDetailPresenter: NewsDetailPresenterProtocol {
    
    // View
    weak var view: NewsDetailViewProtocol?

    // Article
    private let article: Article
    
    init(article: Article) {
        self.article = article
    }
    
    func configureLabels() {
        view?.configureLabels(with: article)
    }
    
    func downloadImage() {
        
        guard let imageString = article.urlToImage,
              let url = URL(string: imageString) else {
            return
        }
        
        ImageDownloader.downloadImage(forURL: url) { [weak self] result in
            
            switch result {
            case .success(let image):
                self?.view?.configureImage(with: image)
            case .failure(let error):
                print("Error", error)
            }
        }
    }
}
