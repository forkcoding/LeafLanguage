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
    static fileprivate var _GlossaryArray: NSDictionary? = nil
    
    static func GetModel() -> NSDictionary? {
        
        if (_GlossaryArray == nil) {
            
            if let data = DataIO.Read(GLOSSARY_PATH) {
                let dataJason: AnyObject? = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject?
                 _GlossaryArray = dataJason as? NSDictionary
            }
        }
        
        return _GlossaryArray
    }
    
    static func SetModel(_ array: NSDictionary) {
        _GlossaryArray = array
    }
    
    static func SaveModel() {
        
        let data = try! JSONSerialization.data(withJSONObject: _GlossaryArray as AnyObject, options:JSONSerialization.WritingOptions.prettyPrinted)
        
        DataIO.Write(GLOSSARY_PATH, data: data)
    }
}
