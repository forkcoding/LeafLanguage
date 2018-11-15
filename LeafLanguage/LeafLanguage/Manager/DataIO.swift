//
//  DataIO.swift
//  LeafLanguage
//
//  Created by LeafMaple on 16/6/14.
//  Copyright © 2016年 LeafMaple. All rights reserved.
//

import Foundation

class DataIO {
    
    static func Write(_ fileName: String, directory: String, data: Data) {
        let fileManager = FileManager.default
        var sharedURL: URL? = fileManager.containerURL(forSecurityApplicationGroupIdentifier: LeafConfig.APP_GROUP_ID)
        if let sharedURL = sharedURL {
            let SQLiteDB = sharedURL.appendingPathComponent(fileName)
            
        }
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        
        let directioryPath = path.appendingPathComponent(directory)
        if (fileManager.fileExists(atPath: directioryPath)) {
            try! fileManager.createDirectory(atPath: directioryPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        let filePath = (directioryPath as NSString).appendingPathComponent(fileName)
        try? data.write(to: URL(fileURLWithPath: filePath), options: [.atomic])
    }
    
    static func CreateDirectory(_ directory: String) {
        
        let fileManager = FileManager.default
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        
        let directioryPath = path.appendingPathComponent(directory)
        if (!fileManager.fileExists(atPath: directioryPath)) {
            try! fileManager.createDirectory(atPath: directioryPath, withIntermediateDirectories: true, attributes: nil)
        }

    }
    
    static func Write(_ fileName: String, data: Data) {
        let fileManager = FileManager.default
        var sharedURL: URL? = fileManager.containerURL(forSecurityApplicationGroupIdentifier: LeafConfig.APP_GROUP_ID)
        if let sharedURL = sharedURL {
            let filePath = sharedURL.appendingPathComponent(fileName)
            try? data.write(to: filePath, options: [.atomic])
        }
        
        /*let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let filePath = path.appendingPathComponent(fileName)
        
        try? data.write(to: URL(fileURLWithPath: filePath), options: [.atomic])*/
    }
    
    static func Read(_ fileName: String) -> Data? {
        let fileManager = FileManager.default
        var sharedURL: URL? = fileManager.containerURL(forSecurityApplicationGroupIdentifier: LeafConfig.APP_GROUP_ID)
        if let sharedURL = sharedURL {
            let filePath = sharedURL.appendingPathComponent(fileName)
            if (fileManager.fileExists(atPath: filePath.path)) {
                return try? Data(contentsOf: filePath)
            }
        }
        
        /*
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let filePath = path.appendingPathComponent(fileName)
        
        if (fileManager.fileExists(atPath: filePath)) {
            return fileManager.contents(atPath: filePath)
        }
        */
        
        return nil
    }
}
