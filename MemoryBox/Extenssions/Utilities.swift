//
//  FileManager+Extensions.swift
//  MemoryBox
//
//  Created by Krystyna Kruchkovska on 26.03.2020.
//  Copyright © 2020 Krystyna Kruchkovska. All rights reserved.
//

import UIKit

func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

func urlWithPathExtension(_ path: PathExtension, for memory: URL) -> URL {
    return memory.appendingPathExtension(path.rawValue)
}

