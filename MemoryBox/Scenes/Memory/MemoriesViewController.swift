//
//  MemoriesViewController.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 21.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import UIKit

protocol MemoriesViewControllerDelegate {
    func addImageTapped()
}

class MemoriesViewController: UICollectionViewController {
    
    private var viewModel: MemoriesViewModel!
    private var delegate: MemoriesViewControllerDelegate
    
    init(viewModel: MemoriesViewModel, delegate: MemoriesViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionClasses()
        viewModel.loadMemories { [unowned self] _ in
             self.collectionView.reloadSections(IndexSet(integer: 1))
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        delegate.addImageTapped()
    }
    
    @objc func memoryLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let cell = sender.view as! MemoryCell

//            if let index = collectionView?.indexPath(for: cell) {
//                activeMemory = filteredMemories[index.row]
//                recordMemory()
//            }
//        } else if sender.state == .ended {
//            finishRecording(success: true)
       }
    }
    
    private func registerCollectionClasses() {
        collectionView!.register(MemoryCell.self, forCellWithReuseIdentifier: MemoryCell.reuseIdentifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: SectionHeaderView.headerId)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return viewModel.memoriesManager.filteredMemories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryCell.reuseIdentifier, for: indexPath) as? MemoryCell else {
            fatalError()
        }
        let memory = viewModel.memoriesManager.filteredMemories[indexPath.row]
        let imageName = viewModel.memoriesManager.appendingPathExtension(.thumbnail, for: memory).path
        let image = UIImage(contentsOfFile: imageName)
        cell.imageView.image = image

        if cell.gestureRecognizers == nil {
            let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(memoryLongPress))
            recognizer.minimumPressDuration = 0.25
            cell.addGestureRecognizer(recognizer)

            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 3
            cell.layer.cornerRadius = 10
        }
       
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.headerId, for: indexPath) as? SectionHeaderView else {
            fatalError("header as SectionHeaderView failed")
        }
        return header
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

// MARK: UICollectionViewDelegateFlowLayout

extension MemoriesViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView:UICollectionView, layout: UICollectionViewLayout, referenceSizeForHeaderInSection: Int) -> CGSize
    {
        if referenceSizeForHeaderInSection > 0 {
            return CGSize.zero
        }
        return CGSize(width:0, height:50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
}
