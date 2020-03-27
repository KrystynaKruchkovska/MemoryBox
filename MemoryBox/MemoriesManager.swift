//
//  MemoriesManager.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 23.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import UIKit
import Speech

protocol MemoriesManagerProtocol {
    func loadMemories(complition: @escaping (_ complited: Bool) -> ())
    func saveNewMemory(image: UIImage)
    func recordMemory()
    var filteredMemories: [URL] { get }
    var recorderDelegate: AVAudioRecorderDelegate? { get set }
    var audioManager : AudioManager { get }
}

class MemoriesManager: MemoriesManagerProtocol {
    
    var recorderDelegate: AVAudioRecorderDelegate? = nil
    public private(set) var filteredMemories = [URL]()
    public private(set) var audioManager : AudioManager
    private var memories = [URL]()
    private var  memoryName : String {
        return "memory-\(Date().timeIntervalSince1970))"
    }

    init(){
        self.audioManager = AudioManager()
    }

    func loadMemories(complition: @escaping (_ complited: Bool) -> ()) {
        memories.removeAll()
        guard let files = try? FileManager.default.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil, options: []) else {
            return
        }
        for file in files {
            let fileName = file.lastPathComponent
            
            if fileName.hasSuffix(".\(PathExtension.thumbnail.rawValue)") {
                let noExtensions = fileName.replacingOccurrences(of: ".\(PathExtension.thumbnail.rawValue)", with: "")
                let memoryPath = getDocumentsDirectory().appendingPathComponent(noExtensions)
                
                memories.append(memoryPath)
                
            }
        }
        filteredMemories = memories
        complition(true)
    }
    
    func saveNewMemory(image: UIImage) {
        let imageName = memoryName + ".\(PathExtension.image.rawValue)"
        let thumbnailName = memoryName + ".\(PathExtension.thumbnail.rawValue)"
        
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
    
    func recordMemory() {
        guard let delegate = recorderDelegate else { return }
        audioManager.recordAudio(recorderDelegate: delegate)
    }
}

enum PathExtension: String {
    case image = "jpeg"
    case thumbnail = "thumb"
    case audio = "m4a"
    case transcription = "txt"
}
