//
//  UniversalDiffableDataSource.swift
//  UniversalDataSourceAndActionProvider
//
//  Created by Сницар Д.А. on 12.07.2022.
//

import UIKit

struct RegistrationKey: Hashable {
    let id: ObjectIdentifier
    let category: UICollectionView.ElementCategory
    let elementKind: String?
}

final class ViewRegistration {
    private let configuration: (UIView, IndexPath, Any) -> Void
    let viewClass: AnyClass
    let reuseIdentifier = UUID().uuidString
    
    init<View, Item>(configuration: @escaping (View, IndexPath, Item) -> Void) where View: UIView {
        self.viewClass = View.self
        self.configuration = { configuration($0 as! View, $1, $2 as! Item) }
    }
    
    func configure(_ view: UIView, indexPath: IndexPath, item: Any) {
        configuration(view, indexPath, item)
    }
}

struct Section<Item: Hashable>: Hashable, Identifiable {
    let id: Int
    let items: [Item]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
}

/// Датасорс списка баз знаний
final class UniversalDiffableDataSource<Item: Hashable>: UICollectionViewDiffableDataSource<Section<Item>, Item> {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section<Item>, Item>
    
    private final class MutableRef<Value> {
        var value: Value
        
        init(_ value: Value) {
            self.value = value
        }
    }
    
    private(set) var sections: [Section<Item>] = []
    private weak var collectionView: UICollectionView?
    private var registrations: MutableRef<[RegistrationKey: ViewRegistration]>
    
    convenience init(collectionView: UICollectionView) {
        self.init(collectionView: collectionView, itemRepresentation: { $0 })
    }
    
    init<T>(collectionView: UICollectionView, itemRepresentation: @escaping (Item) -> T) {
        let registrations = MutableRef<[RegistrationKey: ViewRegistration]>([:])
        let representation: (Item) -> Any = { itemRepresentation($0) }
        self.registrations = registrations
        
        super.init(collectionView: collectionView) { collectionView, indexPath, item in
            let itemType = type(of: representation(item))
            let key = RegistrationKey(id: ObjectIdentifier(itemType), category: .cell, elementKind: nil)
            guard let registration = registrations.value[key] else {
                assertionFailure("No registration for item of type: \(itemType)")
                return UICollectionViewCell()
            }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: registration.reuseIdentifier, for: indexPath)
            registration.configure(cell, indexPath: indexPath, item: item)

            return cell
        }
        
        supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let section = self?.section(at: indexPath.section) else {
                return UICollectionReusableView()
            }
            
            let key = RegistrationKey(id: ObjectIdentifier(type(of: section)), category: .supplementaryView, elementKind: kind)
            
            guard let registration = registrations.value[key] else {
                return UICollectionReusableView()
            }
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: registration.reuseIdentifier, for: indexPath)
            registration.configure(view, indexPath: indexPath, item: section)
            
            return view
        }
        
        self.collectionView = collectionView
    }
    
    private func item(at indexPath: IndexPath) -> Item? {
        guard let items = section(at: indexPath.section)?.items else {
            return nil
        }
        
        return items[indexPath.item]
    }
    
    private func section(at index: Int) -> Section<Item>? {
        guard sections.indices.contains(index) else {
            return nil
        }
        
        return sections[index]
    }
    
    func reload(_ sections: [Section<Item>]) {
        self.sections = sections
        
        var snapshot = Snapshot()
        snapshot.appendSections(sections)
        sections.forEach { snapshot.appendItems($0.items, toSection: $0) }
        apply(snapshot, animatingDifferences: false)
    }
    
    func registerCell<Item, Cell>(itemType: Item.Type, cellType: Cell.Type, configuration: @escaping (Cell, IndexPath, Item) -> Void) where Cell: UICollectionViewCell {
        let key = RegistrationKey(id: .init(itemType), category: .cell, elementKind: nil)
        let registration = ViewRegistration(configuration: configuration)
        registrations.value[key] = registration
        collectionView?.register(registration.viewClass, forCellWithReuseIdentifier: registration.reuseIdentifier)
    }
    
    func registerSupplementaryView<View>(viewType: View.Type, kind: String, configuration: @escaping (View, IndexPath, Section<AnyHashable>) -> Void) where View: UICollectionReusableView {
        let key = RegistrationKey(id: .init(Section<AnyHashable>.self), category: .supplementaryView, elementKind: kind)
        let registration = ViewRegistration(configuration: configuration)
        registrations.value[key] = registration
        collectionView?.register(registration.viewClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: registration.reuseIdentifier)
    }
}

protocol ConfigurableView: UIView {
    associatedtype ViewModel
    func configure(with viewModel: ViewModel)
}

extension UniversalDiffableDataSource {
    func registerCell<Item, Cell>(itemType: Item.Type, cellType: Cell.Type) where Cell: UICollectionViewCell, Cell: ConfigurableView, Cell.ViewModel == Item {
        registerCell(itemType: itemType, cellType: cellType) { cell, _, item in
            cell.configure(with: item)
        }
    }
    
    func registerCellType<Cell>(_ cellType: Cell.Type) where Cell: UICollectionViewCell, Cell: ConfigurableView {
        registerCell(itemType: Cell.ViewModel.self, cellType: cellType) { cell, _, item in
            cell.configure(with: item)
        }
    }
}
