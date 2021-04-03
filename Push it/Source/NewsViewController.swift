//
//  NewsViewController.swift
//  Push it
//
//  Created by Bart de Bruin on 17/03/2021.
//

import UIKit
import Combine

class NewsViewController: UIViewController {
    
    private let viewModel = NewsViewModel()

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindObservables()
        viewModel.getNews()
    }
    
    func bindObservables() {
        
        viewModel.refreshState = { [weak self] in
            
            guard let self = self else {
                return
            }
            
            switch self.viewModel.state {
            case .initial, .loading:
        
                print("loading")
            case .result:
                print("result")

            case .error(let error):
                print("error: ", error)
            }
        }
    }
}

