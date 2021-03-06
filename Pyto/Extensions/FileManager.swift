//
//  FileManager.swift
//  Pyto
//
//  Created by Adrian Labbé on 2/3/19.
//  Copyright © 2019 Adrian Labbé. All rights reserved.
//

import Foundation

extension FileManager {
    
    /// Returns the `URL` of the directory shared between targets.
    var sharedDirectory: URL? {
        guard let url = containerURL(forSecurityApplicationGroupIdentifier: "group.pyto")?.appendingPathComponent("Documents") else {
            return nil
        }
        
        if !fileExists(atPath: url.path) {
            try? createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return url
    }
}
