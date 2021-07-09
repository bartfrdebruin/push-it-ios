//
//  NewsDetailViewController.swift
//  Push it
//
//  Created by Bart on 02/05/2021.
//

import UIKit

class NewsDetailViewController: UIViewController {

    // UI
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    // Presenter
    private let presenter: NewsDetailPresenter

    init?(coder: NSCoder, presenter: NewsDetailPresenter) {
        self.presenter = presenter
        super.init(coder: coder)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with an article.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
    }
    
    func configureImage(with image: UIImage) {
        
        DispatchQueue.main.async {
            self.imageView.image = image
            self.imageView.isHidden = false
        }
    }

    func configureLabels(with article: Article) {

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


