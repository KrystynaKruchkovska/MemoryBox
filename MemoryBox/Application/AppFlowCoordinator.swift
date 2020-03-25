//
//  AppFlowCoordinator.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 21.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import AVFoundation
import Photos
import Speech
import UIKit

class Coordinator {
    var rootViewController = UIViewController()
}

class AppFlowCoordinator: Coordinator {

    private let window: UIWindow
    private var isPermissionAuthorized = false

    init(window: UIWindow) {
        self.window = window
    }

    func initializeApp() {
        let navigationController = UINavigationController()
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "BodoniSvtyTwoITCTT-Bold", size: 17)!]
        rootViewController = navigationController
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        checkPermissions()
        
        if isPermissionAuthorized {
            runMemoriesViewController()
        } else {
            runMainScreen()
        }
    }
    
    func checkPermissions() {
        let photosAuthorized = PHPhotoLibrary.authorizationStatus() == .authorized
        let recordingAuthorized = AVAudioSession.sharedInstance().recordPermission == .granted
        let transcibeAuthorized = SFSpeechRecognizer.authorizationStatus() == .authorized

        isPermissionAuthorized = photosAuthorized && recordingAuthorized && transcibeAuthorized
    }

    private func runMainScreen() {
        let vc = WelcomeViewController(delegate: self,viewModel: WelcomeViewModel())
        vc.title = ControllerTitle.welcomeVC.rawValue
        rootViewController.show(vc, sender: nil)
       
    }
    
    fileprivate func runMemoriesViewController() {
        let viewModel = MemoriesViewModel(memoriesManager: MemoriesManager())
        let memoriesVC = MemoriesViewController(viewModel: viewModel, delegate: self )
        memoriesVC.title = ControllerTitle.memoriesVC.rawValue
        rootViewController.show(memoriesVC, sender: nil)
    }
    
    fileprivate func presentImagePickerController() {
        let vc = UIImagePickerController()
            vc.modalPresentationStyle = .formSheet
        if let navigationVc = rootViewController as? UINavigationController {
            guard let memoriesVc = navigationVc.visibleViewController as? MemoriesViewController else { return }
            vc.delegate = memoriesVc
        }
        rootViewController.present(vc, animated: true)
    }
}

extension AppFlowCoordinator: WelcomeViewControllerdelegate {
    func continuePressed() {
        runMemoriesViewController()
    }
}

extension AppFlowCoordinator: MemoriesViewControllerDelegate {
    func addImageTapped() {
        presentImagePickerController()
    }
    
    
}


enum ControllerTitle: String {
    case welcomeVC = "Welcome"
    case memoriesVC = "Memory Box"
}

