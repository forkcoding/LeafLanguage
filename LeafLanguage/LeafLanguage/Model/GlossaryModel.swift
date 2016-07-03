//
//  GlossaryModel.swift
//  LeafLanguage
//
//  Created by LeafMaple on 16/6/14.
//  Copyright © 2016年 LeafMaple. All rights reserved.
//

import Foundation

class GlossaryModel {
    
    static private let GLOSSARY_PATH = "glossary.jason"
    static private var _GlossaryArray: NSDictionary? = nil
    
    static func GetModel() -> NSDictionary? {
        
        if (_GlossaryArray == nil) {
            
            if let data = DataIO.Read(GLOSSARY_PATH) {
                let dataJason: AnyObject? = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                 _GlossaryArray = dataJason as? NSDictionary
            }
        }
        
        return _GlossaryArray
    }
    
    static func SetModel(array: NSDictionary) {
        _GlossaryArray = array
    }
    
    static func SaveModel() {
        
        let data = try! NSJSONSerialization.dataWithJSONObject(_GlossaryArray as! AnyObject, options:NSJSONWritingOptions.PrettyPrinted)
        
        DataIO.Write(GLOSSARY_PATH, data: data)
    }
}