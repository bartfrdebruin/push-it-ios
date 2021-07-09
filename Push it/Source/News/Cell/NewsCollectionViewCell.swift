//
//  NewsCollectionViewCell.swift
//  Layout
//
//  Created by bart on 28/06/2020.
//  Copyright © 2020 bart. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    // Identifier
    static let identifier = "NewsCollectionViewCell"

    // UI
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    private var task: URLSessionDataTask?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        task?.cancel()
        imageView.image = nil
    }
    
    func configure(with text: String) {
        
        titleLabel.text = text
    }
    
    func configure(with article: Article) {
        
        titleLabel.text = article.title
        
        guard let urlToImage = article.urlToImage else {
            return
        }
        
        task = ImageDownloader.downloadImage(forURL: URL(string: urlToImage)!) { [weak self] (result) in
   
            switch result {
            case let .success(image):
                
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
                
            case .failure(_):
                print("error")
            }
        }
    }
}


