//
//  NewsDetailViewController.swift
//  Push it
//
//  Created by Bart on 02/05/2021.
//

import UIKit
import WebKit
import RxSwift

protocol NewsDetailViewProtocol: AnyObject {
    
    func configureImage(with image: UIImage)
    func configureLabels(with article: Article)
}

class NewsDetailViewController: UIViewController, NewsDetailViewProtocol {

    // UI
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    // Presenter
    private let presenter: NewsDetailPresenterProtocol

    init?(coder: NSCoder, presenter: NewsDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with an presenter!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.configureLabels()
        presenter.downloadImage()
    }
    
    func configureImage(with image: UIImage) {
        
        DispatchQueue.main.async {
            self.imageView.image = image
            self.imageView.isHidden = false
        }
    }
    
    func configureLabels(with article: Article) {

        titleLabel.text = article.title
        
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
        
        sourceLabel.text = article.sourceName
    }
}

// MARK: - Factory
extension NewsDetailViewController {
    
    static func make(with presenter: NewsDetailPresenterProtocol) -> NewsDetailViewController {
 
        let storyboard = UIStoryboard(name: "NewsDetailViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "NewsDetailViewController", creator: { coder in
                return NewsDetailViewController(coder: coder, presenter: presenter)
            })
        
        return vc
    }
}
