//
//  WelcomeViewController.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 21.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import UIKit

protocol WelcomeViewControllerdelegate {
    func continuePressed()
}

class WelcomeViewController: UIViewController {
    
    private var delegate: WelcomeViewControllerdelegate?
    
    private var customView: WelcomeView {
        return view as! WelcomeView
    }
    
    convenience init(delegate: WelcomeViewControllerdelegate) {
        self.init()
        self.delegate = delegate
    }
    
   override func loadView() {
       let detailView = WelcomeView()
       view = detailView
   }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome"
        setupAction()
        
    }
    
    private func setupAction() {
        customView.continueButton.addTarget(self, action: #selector(continuePressed), for: .touchDown)
    }
    
    @objc func continuePressed() {
        delegate?.continuePressed()
    }

}
