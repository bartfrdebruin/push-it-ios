//
//  TextCollectionViewCell.swift
//  Layout
//
//  Created by bart on 28/06/2020.
//  Copyright © 2020 bart. All rights reserved.
//

import UIKit

class TextCollectionViewCell: UICollectionViewCell {
    
    // Identifier
    static let identifier = "TextCollectionViewCell"

    // UI
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var introLabel: UILabel!
    @IBOutlet private weak var paragraphLabel: UILabel!
    
    @IBOutlet private weak var separatorView: UIView!

    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
    }
    
    func configure(with text: String) {
        
        titleLabel.text = text
        introLabel.text = text
        paragraphLabel.text = text
        separatorView.layer.borderColor = UIColor.black.cgColor
        separatorView.layer.borderWidth = 1.0
    }
}


