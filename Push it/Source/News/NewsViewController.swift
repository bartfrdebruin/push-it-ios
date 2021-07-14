//
//  NewsViewController.swift
//  Push it
//
//  Created by Bart de Bruin on 17/03/2021.
//

import UIKit

protocol NewsViewProtocol: AnyObject {
    
    func stopActivityIndicator()
    func showError(with error: Error)
    func configureSnapshot()
    func pushDetailViewController(with article: Article)
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
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier,
                                                          for: indexPath) as! NewsCollectionViewCell
            cell.configure(with: source)
            return cell
        }
    }
}

// MARK: - NewsViewProtocol
extension NewsViewController: NewsViewProtocol {
    
    func configureSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Article>()
        snapshot.appendSections([1])

        snapshot.appendItems(presenter.articles)
        dataSource.apply(snapshot)
    }
    
    func showError(with error: Error) {
        
        activityIndicator.stopAnimating()
        errorLabel.text = error.localizedDescription
        errorLabel.isHidden = false
    }
 
    func stopActivityIndicator() {
       
        activityIndicator.stopAnimating()
    }
    
    func pushDetailViewController(with article: Article) {
        
        let viewController = NewsDetailViewController.make(with: article)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegate
extension NewsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        presenter.didSelectItem(at: indexPath)
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

    static func make(with screenType: ScreenType) -> NewsViewController {
        
        let presenter = NewsPresenter(screenType: screenType)
        let storyboard = UIStoryboard(name: "NewsViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "NewsViewController", creator: { coder in
                return NewsViewController(coder: coder, presenter: presenter)
            })
        
        presenter.view = vc
        return vc
    }
}
