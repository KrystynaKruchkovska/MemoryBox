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
    private var viewModel: WelcomeViewModel!
    
    private var customView: WelcomeView {
        return view as! WelcomeView
    }
    
    convenience init(delegate: WelcomeViewControllerdelegate, viewModel: WelcomeViewModel) {
        self.init()
        self.delegate = delegate
        self.viewModel = viewModel
    }
    
   override func loadView() {
       let detailView = WelcomeView()
       view = detailView
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAction()
    }
    
    private func setupAction() {
        customView.continueButton.addTarget(self, action: #selector(continuePressed), for: .touchDown)
    }
    
    @objc func continuePressed() {
        viewModel.requestAllPermisissions { [unowned self] (error) in
            if let error = error {
                self.customView.textLabel.text = error.localizedDescription
            } else {
                self.delegate?.continuePressed()
            }
        }
    }

}
