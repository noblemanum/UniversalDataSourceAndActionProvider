//
//  SimpleCell.swift
//  UniversalDataSourceAndActionProvider
//
//  Created by Сницар Д.А. on 13.07.2022.
//

import UIKit

struct SimpleCellViewModel: Hashable {
    private let uuid = UUID()
    let title: String
    let subtitle: String?
}

private struct Constants {
    static let padding: CGFloat = 12
}

final class SimpleCell: SeparableCollectionViewCell, ConfigurableView {
    
    private let title = UILabel()
    private let subtitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: SimpleCellViewModel) {
        title.text = viewModel.title
        subtitle.text = viewModel.subtitle
    }
    
    private func configure() {
        [title, subtitle].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            subtitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            subtitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            subtitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding)
        ])
        
        subtitle.font = UIFont.systemFont(ofSize: 12)
        subtitle.textColor = .gray
    }
}
