//
//  TileViewController.swift
//  UniversalDataSourceAndActionProvider
//
//  Created by Сницар Д.А. on 14.07.2022.
//

import UIKit

final class TileViewController: UIViewController {
    
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(imageView)
        view.backgroundColor = .white
        
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setupImage(_ imageName: String?) {
        guard let imageName = imageName else {
            return
        }

        imageView.image = UIImage(systemName: imageName)
    }
}
