//
//  AlertCell.swift
//  UniversalDataSourceAndActionProvider
//
//  Created by Сницар Д.А. on 13.07.2022.
//

import UIKit

struct AlertCellViewModel: Hashable {
    private let uuid = UUID()
    let title: String
    let icon: String
}

private struct Constants {
    static let padding: CGFloat = 12
}

final class AlertCell: SeparableCollectionViewCell, ConfigurableView {
    
    private let title = UILabel()
    private let iconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: AlertCellViewModel) {
        title.text = viewModel.title
        iconView.image = UIImage(systemName: viewModel.icon)
    }
    
    private func configure() {
        [title, iconView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            title.trailingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: -Constants.padding),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding),
            
            iconView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding / 2),
            iconView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            iconView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding / 2),
            iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor)
        ])
        
        iconView.backgroundColor = .yellow
        iconView.tintColor = .black
    }
}

