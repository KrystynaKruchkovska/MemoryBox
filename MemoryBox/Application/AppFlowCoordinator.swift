//
//  AppFlowCoordinator.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 21.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import UIKit

class Coordinator {
        var rootViewController = UIViewController()
}

class AppFlowCoordinator: Coordinator {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func initializeApp() {
        let navigationController = UINavigationController()
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "BodoniSvtyTwoITCTT-Bold", size: 17)!]
        rootViewController = navigationController
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        runMainScreen()
    }

    private func runMainScreen() {
        let vc = WelcomeViewController(delegate: self)
        rootViewController.show(vc, sender: nil)
       
    }
    
    fileprivate func runMemoryViewController() {
        print("runMemoryViewController is CALLED")
        
    }
}

extension AppFlowCoordinator: WelcomeViewControllerdelegate {
    func continuePressed() {
        runMemoryViewController()
    }
}


