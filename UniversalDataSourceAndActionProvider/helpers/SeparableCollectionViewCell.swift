//
//  SeparableCollectionViewCell.swift
//  UniversalDataSourceAndActionProvider
//
//  Created by Сницар Д.А. on 13.07.2022.
//

import UIKit

open class SeparableCollectionViewCell: UICollectionViewCell {

    /// Настройка отображения сепаратора
    public var isSeparatorHidden: Bool = false {
        didSet {
            separator.isHidden = isSeparatorHidden
        }
    }
    
    /// Инсет сепаратора (можно выставить только left и right)
    public var separatorInset: UIEdgeInsets = .zero {
        didSet {
            setNeedsLayout()
        }
    }
    
    /// Цвет сепаратора
    public var separatorBackground: UIColor = .systemGroupedBackground {
        didSet {
            separator.backgroundColor = separatorBackground
        }
    }
    
    /// Высота сепаратора
    public var separatorHeight: CGFloat = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    private let separator = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSeparator()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        configureSeparator()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        // Рассчитываем дополнительную ширину сепаратора, чтобы он заходил на safeArea
        let additionalWidth = superview?.safeAreaInsets.horizontal ?? .zero / 2
        separator.frame = CGRect(x: separatorInset.left,
                                 y: bounds.maxY - separatorHeight,
                                 width: bounds.width + additionalWidth - separatorInset.horizontal,
                                 height: separatorHeight)
    }
    
    private func configureSeparator() {
        self.addSubview(separator)
        separator.backgroundColor = separatorBackground
    }
}

private extension UIEdgeInsets {
    var horizontal: CGFloat {
        return left + right
    }
}
