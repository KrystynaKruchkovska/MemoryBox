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


protocol PhotoPermission {
    func requestPhotosPermissions(complition: @escaping (_ error:Error?) -> ())
}
protocol RecordPermission {
    func requestRecordPermissions(complition: @escaping (_ error:Error?) -> ())
}
protocol TranscribePermissions {
    func requestTranscribePermissions(complition: @escaping (_ error:Error?) -> ())
}

class UserPermission: PhotoPermission, RecordPermission, TranscribePermissions {
    
    public private(set) var authorizationComplete: Bool = false
    
    func requestPhotosPermissions(complition: @escaping (_ error:Error?) -> ()) {
        PHPhotoLibrary.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self.requestRecordPermissions { (error) in
                        if let requestRecordError = error {
                            complition(requestRecordError)
                        }
                    }
                } else {
                    complition(PermissionError.photo)
                }
            }
        }
    }
    
    func requestRecordPermissions(complition: @escaping (_ error:Error?) -> ()) {
        AVAudioSession.sharedInstance().requestRecordPermission() { [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    self.requestTranscribePermissions { (error) in
                        if let requestTranscribeError = error {
                            complition(requestTranscribeError)
                        }
                    }
                } else {
                    complition(PermissionError.recording)
                }
            }
        }
    }
    
    func requestTranscribePermissions(complition: @escaping (_ error:Error?) -> ()) {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self.authorizationComplete = true
                } else {
                    complition(PermissionError.transcription)
                }
            }
        }
    }
    
}
