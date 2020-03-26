//
//  MemoriesViewModel.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 23.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import UIKit
import Speech

class MemoriesViewModel {
    var memoriesManager: MemoriesManagerProtocol!
    var recordDelegate: AVAudioRecorderDelegate!
        
    
    init(memoriesManager: MemoriesManagerProtocol ){
        self.memoriesManager = memoriesManager
        self.memoriesManager.recorderDelegate = recordDelegate
    }
    
    func loadMemories(complition: @escaping (_ complited: Bool) -> ()) {
        memoriesManager.loadMemories { (complited) in
            complition(complited)
        }
    }
    
    func saveNewMemory(image: UIImage) {
        memoriesManager.saveNewMemory(image: image)
    }
    
}
