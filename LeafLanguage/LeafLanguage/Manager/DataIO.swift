//
//  DataIO.swift
//  LeafLanguage
//
//  Created by LeafMaple on 16/6/14.
//  Copyright © 2016年 LeafMaple. All rights reserved.
//

import Foundation

class DataIO {
    
    static func Write(fileName: String, directory: String, data: NSData) {
        
        let fileManager = NSFileManager.defaultManager()
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let path = paths[0] as NSString
        
        let directioryPath = path.stringByAppendingPathComponent(directory)
        if (fileManager.fileExistsAtPath(directioryPath)) {
            try! fileManager.createDirectoryAtPath(directioryPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        let filePath = (directioryPath as NSString).stringByAppendingPathComponent(fileName)
        data.writeToFile(filePath, atomically: true)
    }
    
    static func CreateDirectory(directory: String) {
        
        let fileManager = NSFileManager.defaultManager()
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let path = paths[0] as NSString
        
        let directioryPath = path.stringByAppendingPathComponent(directory)
        if (!fileManager.fileExistsAtPath(directioryPath)) {
            try! fileManager.createDirectoryAtPath(directioryPath, withIntermediateDirectories: true, attributes: nil)
        }

    }
    
    static func Write(fileName: String, data: NSData) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let path = paths[0] as NSString
        let filePath = path.stringByAppendingPathComponent(fileName)
        
        data.writeToFile(filePath, atomically: true)
    }
    
    static func Read(fileName: String) -> NSData? {
        
        let fileManager = NSFileManager.defaultManager()
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let path = paths[0] as NSString
        let filePath = path.stringByAppendingPathComponent(fileName)
        
        if (fileManager.fileExistsAtPath(filePath)) {
            return fileManager.contentsAtPath(filePath)
        }
        
        return nil
    }
}