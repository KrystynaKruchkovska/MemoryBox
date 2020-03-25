//
//  MemoriesManager.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 23.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import UIKit

protocol MemoriesManagerProtocol {
    func loadMemories(complition: @escaping (_ complited: Bool) -> ())
    func saveNewMemory(image: UIImage)
    func appendingPathExtension(_ path: PathExtension, for memory: URL) -> URL
    var filteredMemories: [URL] { get }
}

class MemoriesManager: MemoriesManagerProtocol {
    
    private var memories = [URL]()
    public private(set) var filteredMemories = [URL]()
    
    private var  memoryName : String {
        return "memory-\(Date().timeIntervalSince1970))"
    }
    
    func loadMemories(complition: @escaping (_ complited: Bool) -> ()) {
        memories.removeAll()
        guard let files = try? FileManager.default.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil, options: []) else {
            return
        }
        for file in files {
            let fileName = file.lastPathComponent
            
            if fileName.hasSuffix(".thumb") {
                let noExtensions = fileName.replacingOccurrences(of: ".thumb", with: "")
                let memoryPath = getDocumentsDirectory().appendingPathComponent(noExtensions)
                
                memories.append(memoryPath)
                
            }
        }
        filteredMemories = memories
        complition(true)
    }
    
    func saveNewMemory(image: UIImage) {
        let imageName = memoryName + ".jpeg"
        let thumbnailName = memoryName + ".thumb"
        
        do {
            let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
            
            if let jpegData = image.jpegData(compressionQuality: 80) {
                try jpegData.write(to: imagePath, options: [.atomic])
            }
            
            if let thumbnail = image.resize(to: 200) {
                        let imagePath = getDocumentsDirectory().appendingPathComponent(thumbnailName)
                        if let jpegData = thumbnail.jpegData(compressionQuality: 80) {
                            try jpegData.write(to: imagePath, options: [.atomicWrite])
                        }
                    }
        } catch {
            assert(false, "cant save image")
        }
        
    }
    
    func appendingPathExtension(_ path: PathExtension, for memory: URL) -> URL {
        return memory.appendingPathExtension(path.rawValue)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}


enum PathExtension: String {
    case image = "jpeg"
    case thumbnail = "thumb"
    case audio = "m4a"
    case transcription = "txt"
}
