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
    
    // ViewModel
    private let viewModel: NewsViewModel

    // Rx
    private let disposeBag = DisposeBag()
    
    // DataSource
    private lazy var dataSource = configureDataSource()
    
    init?(coder: NSCoder, viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with an viewModel!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindObservables()
        configureCollectionView()
        viewModel.getNews()
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
    
    func configureSnapshot() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Article>()
        snapshot.appendSections([1])

        snapshot.appendItems(viewModel.articles)
        dataSource.apply(snapshot)
    }
    
    func bindObservables() {
        
        viewModel.stateObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] articles in
                
                guard let self = self else {
                    return
                }
                
                self.configureSnapshot()
                self.activityIndicator.stopAnimating()
                
            }, onError: { [weak self] error in
                
                guard let self = self else {
                    return
                }
                
                self.errorLabel.text = error.localizedDescription
                self.errorLabel.isHidden = false
                self.activityIndicator.stopAnimating()
                
            }).disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegate
extension NewsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard viewModel.numberOfArticles() > indexPath.item,
              let article = viewModel.article(at: indexPath) else {
            return
        }

        let vc = NewsDetailViewController.make(with: article)
        navigationController?.pushViewController(vc, animated: true)
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
        
        let viewModel = NewsViewModel(screenType: screenType)
        let storyboard = UIStoryboard(name: "NewsViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(
            identifier: "NewsViewController", creator: { coder in
                return NewsViewController(coder: coder, viewModel: viewModel)
            })
        
        return vc
    }
}
