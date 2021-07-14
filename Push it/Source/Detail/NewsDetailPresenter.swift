//
//  NewsDetailPresenter.swift
//  Push it
//
//  Created by Bart on 04/07/2021.
//

import UIKit

protocol NewsDetailPresenterProtocol {
    
    var view: NewsDetailViewProtocol! { get }
    var article: Article { get set }
    func downloadImage()
    func configureLabels()
}

class NewsDetailPresenter: NewsDetailPresenterProtocol {
    
    weak var view: NewsDetailViewProtocol!
    
    var article: Article

    init(article: Article) {
        self.article = article
    }
    
    func viewDidLoad() {
        
        downloadImage()
        view.configureLabels(with: article)
    }
    
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

    func configureLabels() {
        
        view.configureLabels(with: article)
    }
}
