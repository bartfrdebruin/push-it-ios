//
//  NewsDetailViewController.swift
//  Push it
//
//  Created by Bart on 02/05/2021.
//

import UIKit
import WebKit
import RxSwift

class NewsDetailViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    private let article: Article
    
    private let disposeBag = DisposeBag()
    
    init?(coder: NSCoder, article: Article) {
        self.article = article
        super.init(coder: coder)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with an article.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLabels()
        configureImage()
    }

    private func configureLabels() {
  
        titleLabel.text = article.title
        titleLabel.isHidden = false
        
        if let author = article.author {
            authorLabel.text = author
            authorLabel.isHidden = false
        }
        
        if let content = article.content {
            contentLabel.text = content
            contentLabel.isHidden = false
        }
        
        if let description = article.description {
            descriptionLabel.text = description
            descriptionLabel.isHidden = false
        }
        
        sourceLabel.text = article.source.name
        sourceLabel.isHidden = false
    }
}

// MARK: - ImageDownLoader
extension NewsDetailViewController {
    
    private func configureImage() {
        
        guard let imageString = article.urlToImage,
              let url = URL(string: imageString) else {
            return
        }
        
        ImageDownloader.downloadImage(forURL: url) { [weak self] result in
            
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.imageView.image = image
                    self?.imageView.isHidden = false
                }
            case .failure(let error):
                print("Error", error)
            }
        }
    }
}

// MARK: - Factory
extension NewsDetailViewController {
    
    static func make(with article: Article) -> NewsDetailViewController {
        
        let storyboard = UIStoryboard(name: "NewsDetailViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "NewsDetailViewController", creator: { coder in
                return NewsDetailViewController(coder: coder, article: article)
            })
        
        return vc
    }
}


