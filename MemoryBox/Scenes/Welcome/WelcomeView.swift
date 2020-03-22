//
//  WelcomeView.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 21.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import UIKit

struct Font {
    static let textFontName = "Avenir Next"
}

class WelcomeView: UIView {
    
    // MARK: initializers
    init() {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(stackView)
        [textLabel, continueButton ].forEach(stackView.addArrangedSubview)
    }
    
    private func setupConstraints() {
        // stackView
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40)
        ])
    }
    
    
    let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution  = .fill
        stackView.spacing = 50.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "In order to work fully, Memory Box needs to read your photo library, record your voice, and transcribe what you said. When you click the button below you will be asked to grant those permissions, but you can change your mind later in Settings."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let continueButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: Font.textFontName, size: 20)
        button.setTitle("Continue", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

}
