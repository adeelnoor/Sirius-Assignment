//
//  FileServiceProvider.swift
//  Assignment
//
//  Created by Adeel-dev on 3/2/22.
//

import Foundation

class FileServiceProvider {

    let fileServiceType: FileServiceType
    
    static func defaultProvider() -> FileServiceProvider {
        let fileServiceType = FileService()
        return FileServiceProvider(fileServiceType: fileServiceType)
    }
    
    init(fileServiceType: FileServiceType) {
        self.fileServiceType = fileServiceType
    }
}
