//
//  NewsViewController.swift
//  Push it
//
//  Created by Bart de Bruin on 17/03/2021.
//

import UIKit
import RxSwift

protocol NewsViewProtocol: AnyObject {
    
    func configureSnapShot(with articles: [Article])
    func stopLoadingState()
    func showErrorState(with error: Error)
}

class NewsViewController: UIViewController {
    
    // UI
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // Presenter
    private let presenter: NewsPresenterProtocol
    
    // DataSource
    private lazy var dataSource = configureDataSource()
    
    // DisposeBag
    private let disposeBag = DisposeBag()
    
    init?(coder: NSCoder, presenter: NewsPresenterProtocol) {
        self.presenter = presenter
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with an presenter!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        presenter.getNews()
    }
    
    private func configureCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.register(UINib(nibName: NewsCollectionViewCell.identifier, bundle: nil),
                                forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)

        collectionView.collectionViewLayout = layout()
    }
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Int, Article> {
        
        return UICollectionViewDiffableDataSource(collectionView: collectionView) { (collectionView, indexPath, source) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as! NewsCollectionViewCell
            cell.configure(with: source)
            
            return cell
        }
    }
}

// MARK: - NewsViewProtocol
extension NewsViewController: NewsViewProtocol {
 
    func stopLoadingState() {
        activityIndicator.stopAnimating()
    }
    
    func showErrorState(with error: Error) {
        errorLabel.text = error.localizedDescription
        errorLabel.isHidden = false
        activityIndicator.stopAnimating()
    }
    
    func configureSnapShot(with articles: [Article]) {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Article>()
        snapshot.appendSections([1])
        
        snapshot.appendItems(articles)
        dataSource.apply(snapshot)
    }
}

// MARK: - UICollectionViewDelegate
extension NewsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard presenter.articles.count > indexPath.item else {
            return
        }
        
        let article = presenter.articles[indexPath.item]
        presenter.routeToDetail(with: article)
    }
}

// MARK: - CollectionViewFlowLayoutDelegate
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
    
    static func make(with presenter: NewsPresenterProtocol) -> NewsViewController {
        
        let storyboard = UIStoryboard(name: "NewsViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "NewsViewController", creator: { coder in
                return NewsViewController(coder: coder, presenter: presenter)
            })
        return vc
    }
}
