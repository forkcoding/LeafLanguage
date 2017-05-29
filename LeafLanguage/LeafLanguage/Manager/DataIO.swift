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
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let filePath = path.appendingPathComponent(fileName)
        
        try? data.write(to: URL(fileURLWithPath: filePath), options: [.atomic])
    }
    
    static func Read(_ fileName: String) -> Data? {
        
        let fileManager = FileManager.default
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let filePath = path.appendingPathComponent(fileName)
        
        if (fileManager.fileExists(atPath: filePath)) {
            return fileManager.contents(atPath: filePath)
        }
        
        return nil
    }
}
