//
//  NewsViewController.swift
//  Push it
//
//  Created by Bart de Bruin on 17/03/2021.
//

import UIKit
import RxSwift

class NewsViewController: UIViewController {
    
    // UI 
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // DataSource
    private lazy var dataSource = configureDataSource()
    private var articles: [Article] = []
    private let screenType: ScreenType
    
    // Network
    private let networkLayer = PushItNetworkLayer()

    // Rx
    private let disposeBag = DisposeBag()
    
    init?(coder: NSCoder,
          screenType: ScreenType) {
        self.screenType = screenType
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with an article.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        getNews()
    }
    
    func getNews() {

        newsForScreenType()
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (news) in
                
                guard let self = self else {
                    return
                }
                
                self.articles = news.articles
                self.configureSnapshot()
                self.activityIndicator.stopAnimating()
                
            } onFailure: { [weak self] (error) in
                
                guard let self = self else {
                    return
                }
                
                self.activityIndicator.stopAnimating()
                self.errorLabel.text = error.localizedDescription
                self.errorLabel.isHidden = false
                
            }.disposed(by: disposeBag)
    }
    
    private func newsForScreenType() -> Single<News> {
        
        switch screenType {
        case .headlines:
            return networkLayer.headlines()
        case .domestic:
            return networkLayer.domesticNews()
        case .foreign:
            return networkLayer.foreignNews()
        case .sport:
            return networkLayer.headlines()
        case .custom(let query):
            return networkLayer.custom(query: query)
        }
    }
}

// MARK: - CollectionView
extension NewsViewController {
    
    private func configureCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.register(UINib(nibName: NewsCollectionViewCell.identifier, bundle: nil),
                                forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)

        collectionView.collectionViewLayout = layout()
    }
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Int, Article> {
        
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, source) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier,
                                                          for: indexPath) as! NewsCollectionViewCell
                        
            // I know this is not full MVC, this view should be stupid, but doing this overhere would create
            // so much ugly ness, i cannot bear to see it. 
            cell.configure(with: source)
            return cell
        }
    }
    
    func configureSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Article>()
        snapshot.appendSections([1])

        snapshot.appendItems(articles)
        dataSource.apply(snapshot)
    }
}

// MARK: - UICollectionViewDelegate
extension NewsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard articles.count > indexPath.item else {
            return
        }

        let vc = NewsDetailViewController.make(with: articles[indexPath.item])
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CompositionalLayout
extension NewsViewController {
    
    private func layout() -> UICollectionViewLayout {
        
        let fullWidthSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        
        let fullWidthItem = NSCollectionLayoutItem(
            layoutSize: fullWidthSize)

        let mainGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: fullWidthSize,
            subitem: fullWidthItem,
            count: 1)
        
        mainGroup.edgeSpacing = .init(leading: .fixed(0), top: .fixed(2), trailing: .fixed(0), bottom: .fixed(0))
        let section = NSCollectionLayoutSection(group: mainGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - Factory
extension NewsViewController {

    static func make(with screenType: ScreenType) -> NewsViewController {
        
        let storyboard = UIStoryboard(name: "NewsViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "NewsViewController", creator: { coder in
                return NewsViewController(coder: coder, screenType: screenType)
            })
        
        return vc
    }
}
