//
//  SectionHeaderView.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 22.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    
   static private (set) var headerId = "SectionHeader"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Type to search"
        searchBar.tintColor = .white
        searchBar.barTintColor = .black
        searchBar.barStyle = .default
        searchBar.searchBarStyle = .minimal
        searchBar.sizeToFit()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
        
    }()
    
    private func setupView() {
        self.addSubview(searchBar)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
                   searchBar.leftAnchor.constraint(equalTo: self.leftAnchor),
                   searchBar.rightAnchor.constraint(equalTo: self.rightAnchor),
                   searchBar.topAnchor.constraint(equalTo: self.topAnchor),
                   searchBar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
               ])
    }
    

}
