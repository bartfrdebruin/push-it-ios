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

    // UI
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    
    // ViewModel
    private let viewModel: NewsDetailViewModelProtocol
    
    // Rx
    private let disposeBag = DisposeBag()
    
    init?(coder: NSCoder, viewModel: NewsDetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(coder: coder)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with an viewModel!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindObservables()
        viewModel.downloadImage()
        configure()
    }
    
    func bindObservables() {
        
        viewModel.stateObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { state in
                
                switch state.imageState {
                case .result(let image):
                    self.imageView.image = image
                case .noImage:
                    self.imageView.isHidden = true
                default:
                    break
                }
                
            }).disposed(by: disposeBag)
    }

    private func configure() {
        
        titleLabel.text = viewModel.title
        titleLabel.isHidden = false
        
        if let author = viewModel.author {
            authorLabel.text = author
            authorLabel.isHidden = false
        }
        
        if let content = viewModel.content {
            contentLabel.text = content
            contentLabel.isHidden = false
        }
        
        if let description = viewModel.description {
            descriptionLabel.text = description
            descriptionLabel.isHidden = false
        }
        
        sourceLabel.text = viewModel.source
        sourceLabel.isHidden = false
    }
}

// MARK: - Factory
extension NewsDetailViewController {
    
    static func make(with article: Article) -> NewsDetailViewController {
        
        let viewModel = NewsDetailViewModel(article: article)
        let storyboard = UIStoryboard(name: "NewsDetailViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "NewsDetailViewController", creator: { coder in
                return NewsDetailViewController(coder: coder, viewModel: viewModel)
            })
        
        return vc
    }
}


