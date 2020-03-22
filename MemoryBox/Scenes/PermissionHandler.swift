//
//  PermissionHandler.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 21.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import AVFoundation
import Photos
import Speech
import Foundation


enum PermissionError: Error {
    case photo
    case recording
    case transcription
}

extension PermissionError: LocalizedError {
    var errorDescription: String? {
          switch self {
          case .photo:
              return NSLocalizedString(
                  "Photos permission was declined; please enable it in settings then tap Continue again.",
                  comment: ""
              )
          case .recording:
              return NSLocalizedString(
                  "Recording permission was declined; please enable it in settings then tap Continue again.",
                  comment: ""
              )
          case .transcription:
              return NSLocalizedString(
                  "Transcription permission was declined; please enable it in settings then tap Continue again.",
                  comment: ""
              )
          }
      }
}


protocol MemoryBoxPermission {
    func requestAllPermisissions(complition: @escaping (_ error:Error?) -> ())
}

class PermissionHandler: MemoryBoxPermission {
    
    func requestAllPermisissions(complition: @escaping (_ error:Error?) -> ()) {
    
        requestPhotosPermissions { (error) in
            if let photoError = error {
                complition(photoError)
            }
            self.requestRecordPermissions { (error) in
                if let recordError = error {
                    complition(recordError)
                }
                self.requestTranscribePermissions { (error) in
                    if let transcribeError = error {
                        complition(transcribeError)
                    } else {
                        complition(nil)
                    }
                }
            }
        }
        
    }
    
    private func requestPhotosPermissions(complition: @escaping (_ error:Error?) -> ()) {
        PHPhotoLibrary.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                   complition(nil)
                } else {
                    complition(PermissionError.photo)
                }
            }
        }
    }
    
    private func requestRecordPermissions(complition: @escaping (_ error:Error?) -> ()) {
        AVAudioSession.sharedInstance().requestRecordPermission() { allowed in
            DispatchQueue.main.async {
                if allowed {
                    complition(nil)
                } else {
                    complition(PermissionError.recording)
                }
            }
        }
    }
    
    private func requestTranscribePermissions(complition: @escaping (_ error:Error?) -> ()) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    complition(nil)
                } else {
                    complition(PermissionError.transcription)
                }
            }
        }
    }
    
}
