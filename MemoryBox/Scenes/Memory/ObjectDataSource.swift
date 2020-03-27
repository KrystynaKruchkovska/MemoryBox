//
//  ObjectDataSource.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 27.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import UIKit
import Speech

class ObjectDataSource: NSObject, UICollectionViewDataSource {
    
    private var viewModel: MemoriesViewModel
    
    init(viewModel: MemoriesViewModel) {
        self.viewModel = viewModel
    }
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return viewModel.memoriesManager.filteredMemories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoryCell.reuseIdentifier, for: indexPath) as? MemoryCell else {
            fatalError()
        }
        let memory = viewModel.memoriesManager.filteredMemories[indexPath.row]
        let imageThumbnail = urlWithPathExtension(.thumbnail, for: memory).path
        let image = UIImage(contentsOfFile: imageThumbnail)
        cell.imageView.image = image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.headerId, for: indexPath) as? SectionHeaderView else {
            fatalError("header as SectionHeaderView failed")
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memory = viewModel.memoriesManager.filteredMemories[indexPath.row]
        let fm = FileManager.default
        
        do {
            let audioName = urlWithPathExtension(.audio, for: memory)
            let transcriptionName = urlWithPathExtension(.transcription, for: memory)
            var audioPlayer = viewModel.memoriesManager.audioManager.audioPlayer
            
            if fm.fileExists(atPath: audioName.path) {
                audioPlayer = try AVAudioPlayer(contentsOf: audioName)
                audioPlayer?.play()
            }
            
            if fm.fileExists(atPath: transcriptionName.path) {
                let contents = try String(contentsOf: transcriptionName)
                print(contents)
            }
        } catch {
            assert(false, "Error loading audio")
        }
    }
}

