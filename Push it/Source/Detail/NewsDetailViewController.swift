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
    
    @IBOutlet private weak var webView: WKWebView!
    
    private let viewModel: NewsDetailViewModel
    
    private let disposeBag = DisposeBag()
    
    init?(coder: NSCoder, viewModel: NewsDetailViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with an article.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindObservables()
    }
    
    private func bindObservables() {
        
        viewModel.observableURL
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (event) in
    
                guard let element = event.element,
                      let url = element else {
                    return
                }
                
                self?.webView.load(URLRequest(url: url))
                
            }.disposed(by: disposeBag)
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


