//
//  AudioManager.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 26.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import Speech

class AudioManager {
    
    var audioRecorder: AVAudioRecorder?
    var activeMemory: URL?
    
    private var recordingURL: URL {
        return getDocumentsDirectory().appendingPathComponent("recording.m4a")
    }
    
    func recordAudio(recorderDelegate: AVAudioRecorderDelegate) {
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try recordingSession.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
            audioRecorder?.delegate = recorderDelegate
            audioRecorder?.record()
        } catch let error {
            fatalError("Failed to record: \(error)")
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        
        if success {
            do {
                guard let activeMemory = activeMemory else {
                    return
                }
                let memoryAudioURL = activeMemory.appendingPathExtension("m4a")
                let fm = FileManager.default
                
                if fm.fileExists(atPath: memoryAudioURL.path) {
                    try fm.removeItem(at: memoryAudioURL)
                }
                
                try fm.moveItem(at: recordingURL, to: memoryAudioURL)
                
                transcribeAudio(memory: activeMemory)
            } catch let error {
                print("Failure finishing recording: \(error)")
            }
        }
    }
    
    func transcribeAudio(memory: URL) {
        let audio = urlWithPathExtension(.audio, for: memory)
        
        let transcription = urlWithPathExtension(.transcription, for: memory)
        
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: audio)
        recognizer?.recognitionTask(with: request) { (result, error) in
            guard let result = result else {
                fatalError("There was an error: \(error!)")
            }
            if result.isFinal {
                let text = result.bestTranscription.formattedString
                do {
                    try text.write(to: transcription, atomically: true, encoding: String.Encoding.utf8)
                    //self.indexMemory(memory: memory, text: text)
                } catch {
                    print("Failed to save transcription.")
                }
            }
        }
    }
    
}
