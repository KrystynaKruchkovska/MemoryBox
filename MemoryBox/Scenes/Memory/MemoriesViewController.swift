//
//  MemoriesViewController.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 21.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import UIKit
import Speech

protocol MemoriesViewControllerDelegate {
    func addImageTapped()
}

class MemoriesViewController: UICollectionViewController {
    
    private var viewModel: MemoriesViewModel!
    private var delegate: MemoriesViewControllerDelegate
    private var objectFlowLayout: UICollectionViewDelegateFlowLayout
    private var objectDataSource: UICollectionViewDataSource
    
    init(viewModel: MemoriesViewModel, delegate: MemoriesViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.objectFlowLayout = ObjectFlowLayout()
        self.objectDataSource = ObjectDataSource(viewModel: viewModel)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = objectDataSource
        collectionView.delegate = objectFlowLayout
        registerCollectionClasses()
        viewModel.recordDelegate = self
        viewModel.loadMemories { [unowned self] _ in
             self.collectionView.reloadSections(IndexSet(integer: 1))
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        delegate.addImageTapped()
    }
        
    private func registerCollectionClasses() {
        collectionView!.register(MemoryCell.self, forCellWithReuseIdentifier: MemoryCell.reuseIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: SectionHeaderView.headerId)
    }
}

extension MemoriesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        
        if let chosenImage = info[.originalImage] as? UIImage {
            viewModel.saveNewMemory(image: chosenImage)
            viewModel.loadMemories { [unowned self] _ in
                self.collectionView.reloadSections(IndexSet(integer: 1))
            }
        }
    }
}


extension MemoriesViewController: CollectionViewDelegate {
    func memoryPressed(sender: UITapGestureRecognizer) {
        if sender.state == .began {
            let cell = sender.view as! MemoryCell
            if let index = collectionView?.indexPath(for: cell) {
                viewModel.memoriesManager.audioManager.activeMemory = viewModel.memoriesManager.filteredMemories[index.row]
                viewModel.memoriesManager.recordMemory()
            }
        } else if sender.state == .ended {
            viewModel.memoriesManager.audioManager.finishRecording(success: true)
        }
    }
}

extension MemoriesViewController: AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            viewModel.memoriesManager.audioManager.finishRecording(success: false)
        }
    }
}
