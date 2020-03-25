//
//  MemoriesViewModel.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 23.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import UIKit

class MemoriesViewModel {
    var memoriesManager: MemoriesManagerProtocol!
    
    init(memoriesManager: MemoriesManagerProtocol){
        self.memoriesManager = memoriesManager
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
