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
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // DataSource
    private lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindObservables()
        configureCollectionView()
        viewModel.getNews()
    }
    
    private func configureCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.register(UINib(nibName: TextCollectionViewCell.identifier, bundle: nil),
                                forCellWithReuseIdentifier: TextCollectionViewCell.identifier)

        collectionView.collectionViewLayout = layout()
    }
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Int, Article> {
        
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, source) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionViewCell.identifier, for: indexPath) as! TextCollectionViewCell
            cell.configure(with: source.title)
            
            return cell
        }
    }
    
    func configureSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Article>()
        snapshot.appendSections([1])

        snapshot.appendItems(viewModel.articles)
        dataSource.apply(snapshot)
    }
    
    
    func bindObservables() {
        
        viewModel.refreshState = { [weak self] in
            
            guard let self = self else {
                return
            }
            
            switch self.viewModel.state {
            case .initial, .loading:
        
                self.activityIndicator.startAnimating()
                print("loading")
            case .result:
                
                DispatchQueue.main.sync {
                    self.activityIndicator.stopAnimating()
                    self.errorLabel.isHidden = true
                    self.configureSnapshot()
                }

            case .error(let error):
                print("error: ", error)
            }
        }
    }
}

extension NewsViewController: UICollectionViewDelegate {
    
}

// MARK: - CollectionViewFlowLayoutDelegate
extension NewsViewController {
    
    private func layout() -> UICollectionViewLayout {
        
        let heroItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(2/3),
            heightDimension: .estimated(550)
        )
        
        let heroItem = NSCollectionLayoutItem(layoutSize: heroItemSize)
        
        let sideKickItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(49)
        )
        
        let sideKickItem = NSCollectionLayoutItem(layoutSize: sideKickItemSize)
        
        let sideKickGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .estimated(49)
        )
        
        let sideKickGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: sideKickGroupSize,
            subitems: [sideKickItem, sideKickItem]
        )
        
        let topGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        
        let topGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: topGroupSize,
            subitems: [heroItem, sideKickGroup]
        )
        
        let section = NSCollectionLayoutSection(group: topGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

extension NewsViewController {
    
    static func make() -> NewsViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newsViewController = storyboard.instantiateViewController(identifier: "NewsViewController")
        return newsViewController as! NewsViewController
    }
}
