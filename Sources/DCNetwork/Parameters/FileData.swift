//
//  FileData.swift
//  DCNetwork
//
//  Created by David Cortes on 14/10/24.
//

import Foundation

public struct FileData {
    let name: String
    let fileName: String
    let mimeType: MimeType
    let data: Data
    
    public init(name: String, fileName: String, mimeType: MimeType, data: Data) {
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
    }
}
