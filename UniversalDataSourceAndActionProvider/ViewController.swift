//
//  ViewController.swift
//  UniversalDataSourceAndActionProvider
//
//  Created by Сницар Д.А. on 12.07.2022.
//

import UIKit

private struct Constants {
    static let minItemsNumberBeforeListEnd: Int = 3
}

final class ViewController: UIViewController {

    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    )
    
    private let service = ItemsService()
    
    private(set) lazy var dataSource = UniversalDiffableDataSource<AnyHashable>(
        collectionView: collectionView,
        itemRepresentation: { $0.base }
    )
    
    private var items = [Item]()
    private var viewModels = [AnyHashable]()
    
    private var collectionScrollObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Universal DataSource"
        
        setupCollectionView()
        setupDataSource()
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionScrollObservation = collectionView.observe(\.contentOffset, options: [.old, .new]) { [weak self] collectionView, observedChange in
            guard
                let self = self,
                let old = observedChange.oldValue?.y,
                let new = observedChange.newValue?.y,
                old != new
            else {
                return
            }
            
            if let maxVisibleItemIndex = collectionView.indexPathsForVisibleItems.max()?.item,
               new > old,
               (maxVisibleItemIndex >= self.viewModels.count - Constants.minItemsNumberBeforeListEnd) && (self.viewModels.count > Constants.minItemsNumberBeforeListEnd) {
                
                self.loadData()
            }
        }
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
                view.configure(with: "Section \(indexPath.section + 1)")
            }
        )
        
        dataSource.registerCellType(TileCell.self)
        dataSource.registerCellType(SimpleCell.self)
        dataSource.registerCellType(AlertCell.self)
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in

            let heightDimension = NSCollectionLayoutDimension.estimated(100)
            
            // Item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: heightDimension)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            // Group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: heightDimension)
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
            section.interGroupSpacing = .zero
            return section
        }
        return layout
    }
    
    private func loadData() {
        service.fetchPage(anchor: items.last?.anchor) { [weak self] items in
            guard let self = self, !items.isEmpty else { return }
            
            self.items.append(contentsOf: items)
            self.viewModels.append(contentsOf: Mapper.map(items))
            
            DispatchQueue.main.async {
                self.dataSource.reload([Section(id: .zero, items: self.viewModels)])
            }
        }
    }
}
