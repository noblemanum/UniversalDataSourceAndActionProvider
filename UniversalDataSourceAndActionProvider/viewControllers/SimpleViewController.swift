//
//  SimpleViewController.swift
//  UniversalDataSourceAndActionProvider
//
//  Created by Сницар Д.А. on 14.07.2022.
//

import UIKit

final class SimpleViewController: UIViewController {
    
    private let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(titleLabel)
        view.backgroundColor = .white
        
        titleLabel.textAlignment = .center
        titleLabel.frame = view.bounds
        titleLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setupTitle(_ title: String?) {
        guard let title = title else { return }
        titleLabel.text = title
    }
}
