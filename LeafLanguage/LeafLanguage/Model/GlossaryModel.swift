//
//  GlossaryModel.swift
//  LeafLanguage
//
//  Created by LeafMaple on 16/6/14.
//  Copyright © 2016年 LeafMaple. All rights reserved.
//

import Foundation

class GlossaryModel {
    
    static fileprivate let GLOSSARY_PATH = "glossary.jason"
    static fileprivate var _glsMulDict: NSMutableDictionary? = nil
    
    static private func GetJson() -> AnyObject? {
        var res : AnyObject?
        if let data = DataIO.Read(GLOSSARY_PATH) {
            res = try!JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject?
        }
        return res
    }
    
    static private func SetJson(obj: AnyObject) {
        let json = try! JSONSerialization.data(withJSONObject: obj, options:JSONSerialization.WritingOptions.prettyPrinted)
        DataIO.Write(GLOSSARY_PATH, data: json)
    }
    
    static private func GetModel() -> NSMutableDictionary! {
        if (_glsMulDict == nil) {
            if let json = GetJson() {
                _glsMulDict = NSMutableDictionary(dictionary: json as! NSDictionary)
            } else {
                _glsMulDict = NSMutableDictionary()
            }
        }
        return _glsMulDict!
    }
    
    static func SaveModel() {
        if (_glsMulDict != nil) {
            SetJson(obj: _glsMulDict!)
        }
    }
    
    static func SetModel(key: String, value: Int) {
        GetModel()[key] = value
    }
    
    static func Get(key: String) -> Int {
        if let num = GetModel().object(forKey: key) {
            return num as! Int
        } else {
            return 0
        }
    }
    
    static func Add(key: String, num: Int) {
        let dict = GetModel()
        if let value = dict!.object(forKey: key) {
            dict![key] = value as! Int + num
        } else {
            dict![key] = num
        }
    }
    
    static func Remove(key: String) {
        GetModel().removeObject(forKey: key)
    }
    
    static func Count() -> Int {
        return GetModel().count
    }
    
    static func Enumerator() -> NSEnumerator {
        return GetModel().keyEnumerator()
    }
}
