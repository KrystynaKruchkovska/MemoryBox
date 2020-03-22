//
//  WelcomeViewModel.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 21.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import Foundation

class WelcomeViewModel {
    var permisionHandler: MemoryBoxPermission
    
    init() {
        self.permisionHandler = PermissionHandler()
    }
    
    func requestAllPermisissions(complition: @escaping (_ error:Error?) -> ()) {
        permisionHandler.requestAllPermisissions { (error) in
            if let error = error {
                complition(error)
            }
            complition(nil)
        }
    }
    
    
}
