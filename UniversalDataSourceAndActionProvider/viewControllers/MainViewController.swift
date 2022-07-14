//
//  MainViewController.swift
//  UniversalDataSourceAndActionProvider
//
//  Created by Сницар Д.А. on 12.07.2022.
//

import UIKit

private struct Constants {
    static let minItemsNumberBeforeListEnd: Int = 3
}

final class MainViewController: UIViewController {

    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    )
    
    private let actionProvider = ActionProvider<AnyHashable>()
    
    private let service = ItemsService()
    
    private(set) lazy var dataSource = UniversalDiffableDataSource<AnyHashable>(collectionView: collectionView)
    
    private var items = [Item]()
    private var viewModels = [AnyHashable]()
    
    private var collectionScrollObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Universal DataSource"
        
        setupCollectionView()
        setupDataSource()
        setupActionProvider()
        
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
        
        collectionView.delegate = self
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
    
    private func setupActionProvider() {
        actionProvider.registerAction(itemType: TileItem.self) { [weak self] item in
            let controller = TileViewController()
            controller.setupImage(item.imageName)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        actionProvider.registerAction(itemType: SimpleItem.self) { [weak self] item in
            let controller = SimpleViewController()
            controller.setupTitle(item.title)
            controller.modalPresentationStyle = .formSheet
            self?.present(controller, animated: true)
        }
        
        actionProvider.registerAction(itemType: AlertItem.self) { [weak self] item in
            let actionSheetController = UIAlertController(
                title: item.title,
                message: nil,
                preferredStyle: .alert
            )
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
            actionSheetController.addAction(cancelAction)
            
            self?.present(actionSheetController, animated: true)
        }
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


extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let itemContainer = items[indexPath.item]
    
        if let tileItem = itemContainer.tileItem {
            actionProvider.performAction(for: tileItem)
        } else if let simpleItem = itemContainer.simpleItem {
            actionProvider.performAction(for: simpleItem)
        } else if let alertItem = itemContainer.alertItem {
            actionProvider.performAction(for: alertItem)
        }
    }
}
