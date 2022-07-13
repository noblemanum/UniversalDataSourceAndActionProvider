//
//  TileCell.swift
//  UniversalDataSourceAndActionProvider
//
//  Created by Сницар Д.А. on 13.07.2022.
//

import UIKit

struct TileCellViewModel: Hashable {
    private let uuid = UUID()
    let title: String
    let textDescription: String?
    let imageName: String?
}

private struct Constants {
    static let padding: CGFloat = 12
}

final class TileCell: SeparableCollectionViewCell, ConfigurableView {
    
    private let title = UILabel()
    private let subtitle = UILabel()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: TileCellViewModel) {
        title.text = viewModel.title
        subtitle.text = viewModel.textDescription
        
        if let imageName = viewModel.imageName {
            imageView.image = UIImage(systemName: imageName)
        }
    }
    
    private func configure() {
        [title, subtitle, imageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            title.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.padding),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            subtitle.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.padding),
            subtitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            subtitle.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Constants.padding),
            
            imageView.topAnchor.constraint(equalTo: title.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        title.numberOfLines = 1
        
        subtitle.numberOfLines = 2
        subtitle.font = UIFont.systemFont(ofSize: 12)
        subtitle.textColor = .gray
        
        imageView.tintColor = .black
        imageView.backgroundColor = .systemGroupedBackground
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
    }
}
