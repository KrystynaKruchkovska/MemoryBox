//
//  MemoryCell.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 21.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import UIKit

class MemoryCell: UICollectionViewCell {
    
    static private (set) var reuseIdentifier = "MemoryCell"

     override init(frame: CGRect) {
         super.init(frame: frame)
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
         setupView()
         setupConstraints()
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private func setupView() {
        self.addSubview(imageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
                   imageView.leftAnchor.constraint(equalTo: self.leftAnchor),
                   imageView.rightAnchor.constraint(equalTo: self.rightAnchor),
                   imageView.topAnchor.constraint(equalTo: self.topAnchor),
                   imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
               ])
    }
   
}
