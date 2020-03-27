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
    var audioPlayer: AVAudioPlayer?
    private var searchSpotlightManager: SearchSpotlightManager
    
    init(){
           self.searchSpotlightManager = SearchSpotlightManager()
       }
    
    private var recordingURL: URL {
        return getDocumentsDirectory().appendingPathComponent("recording.m4a")
    }
    
    func recordAudio(recorderDelegate: AVAudioRecorderDelegate) {
        audioPlayer?.stop()
        
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
            assert(false, "Failed to record: \(error)")
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
                assert(false, "Failure finishing recording: \(error)")
            }
        }
    }
    
    func transcribeAudio(memory: URL) {
        let memoryAudioUrl = urlWithPathExtension(.audio, for: memory)
        let memoryTranscriptionUrl = urlWithPathExtension(.transcription, for: memory)
        
        let recognizer = SFSpeechRecognizer()
        let request = SFSpeechURLRecognitionRequest(url: memoryAudioUrl)
        recognizer?.recognitionTask(with: request) { [unowned self] (result, error) in
            guard let result = result else {
                assert(false, "There was an error: \(error!)")
            }
            if result.isFinal {
                let text = result.bestTranscription.formattedString
                do {
                    try text.write(to: memoryTranscriptionUrl, atomically: true, encoding: String.Encoding.utf8)
                    self.searchSpotlightManager.indexMemory(memory: memory, text: text)
                } catch {
                    assert(false, "Failed to save transcription.")
                }
            }
        }
    }
    
}
