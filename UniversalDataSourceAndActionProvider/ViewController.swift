//
//  ViewController.swift
//  UniversalDataSourceAndActionProvider
//
//  Created by Сницар Д.А. on 12.07.2022.
//

import UIKit

final class ViewController: UIViewController {

    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    )
    
    private(set) lazy var dataSource = UniversalDiffableDataSource<AnyHashable>(
        collectionView: collectionView,
        itemRepresentation: { $0.base }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupDataSource()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .white
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setupDataSource() {
        dataSource.registerSupplementaryView(
            viewType: SimpleHeaderView.self,
            kind: UICollectionView.elementKindSectionHeader,
            configuration: { view, indexPath, _ in
                view.configure(with: "Section \(indexPath.section)")
            }
        )
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in

            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .absolute(130))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            // Header
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .absolute(30.0))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )

            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            section.orthogonalScrollingBehavior = .none
            section.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            section.interGroupSpacing = .zero
            return section
        }
        return layout
    }
}
