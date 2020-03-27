//
//  SearchSpotlightManager.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 27.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import Foundation
import CoreSpotlight
import MobileCoreServices

class SearchSpotlightManager {
    
    func indexMemory(memory: URL, text: String) {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = "Memory Box"
        attributeSet.contentDescription = text
        attributeSet.thumbnailURL = urlWithPathExtension(.thumbnail, for: memory)

        let item = CSSearchableItem(uniqueIdentifier: memory.path, domainIdentifier: "com.kruchkovskakr", attributeSet: attributeSet)
        item.expirationDate = Date.distantFuture

        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully indexed: \(text)")
            }
        }
    }
    
}
