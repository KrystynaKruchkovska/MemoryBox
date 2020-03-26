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
    private var delegate: CollectionViewDelegate?

     override init(frame: CGRect) {
         super.init(frame: frame)
         setupView()
         setupConstraints()
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if self.gestureRecognizers == nil {
            let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(memoryLongPress))
            recognizer.minimumPressDuration = 0.25
            addGestureRecognizer(recognizer)
        }

    }

    @objc func memoryLongPress(sender: UITapGestureRecognizer) {
        delegate?.memoryPressed(sender: sender)
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 4
        return imageView
    }()
    
    private func setupCell() {
        layer.cornerRadius = 4
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 10
    }
    
    private func setupView() {
        setupCell()
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


protocol CollectionViewDelegate {
    func memoryPressed(sender: UITapGestureRecognizer)
}
