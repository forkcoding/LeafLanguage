//
//  VocabularyModel.swift
//  LeafLanguage
//
//  Created by LeafMaple on 16/6/15.
//  Copyright © 2016年 LeafMaple. All rights reserved.
//

import Foundation

class VocabularyModel {
    
    static private let _LessonCountOfGroup = 8
    static private var _Vocabulary: Array<Vocabulary>?
    
    static let LANGUAGE_STRING = ["Japanese", "English"]
    static private let SCRIPT_FILE_NAME = ["Japanese.json", "English.json"]
    
    static private var _LanguageArr = Array<Array<Vocabulary>?>(count: SCRIPT_FILE_NAME.count, repeatedValue: nil)
    static private var _IDArr = Array<Array<Int>?>(count: SCRIPT_FILE_NAME.count, repeatedValue: nil)
    
    static func GetArrayData(language: LANGUAGE) -> Array<Vocabulary> {
        
        var resultArr = Array<Vocabulary>()
        var lsIDArr = Array<Int>()
        
        let scriptData = ReadScript(language)
        let jsonScript = try! NSJSONSerialization.JSONObjectWithData(scriptData!, options: NSJSONReadingOptions.AllowFragments)
            
        let scriptArr = jsonScript as! NSArray
        
        for (lsId, lsObj) in scriptArr.enumerate() {
            
            let soundFileName = (NSString(format: "%03d", language.rawValue) as String)
                + (NSString(format: "%03d", lsId + 1) as String)
            
            let lsArray = lsObj as! NSArray
            
            lsIDArr.append(resultArr.count)
            
            for vocObj in lsArray {
                
                let vocStr = vocObj.objectForKey("Voc") as! String
                let extStr = vocObj.objectForKey("Ext") as! String
                let typeStr = vocObj.objectForKey("Type") as! String
                let meaningStr = vocObj.objectForKey("Meaning") as! String
                let uniqueID = resultArr.count
                
                var startTime = 0.0
                
                let timeObj = vocObj.objectForKey("Time")
                if (timeObj != nil) {
                    startTime = timeObj as! Double
                }
                
                if (uniqueID > 0) {
                    resultArr[uniqueID - 1].SoundEnd = startTime
                }
                
                resultArr.append(Vocabulary(
                    Word:       vocStr,        CNWord:     extStr,
                    WordType:   typeStr,        Meaning:    meaningStr,
                    SoundName:  soundFileName,  SoundStart: startTime,
                    SoundEnd:   0.0,            UniqueID:   uniqueID))

            }
        }
        
        _IDArr[language.rawValue] = lsIDArr
        return resultArr
    }
    
    static func GetVocabulary(language: LANGUAGE, uniqueID: Int) -> Vocabulary? {
        
        if (_LanguageArr[language.rawValue] == nil) {
            _LanguageArr[language.rawValue] = GetArrayData(language)
        }
        
        if (uniqueID < _LanguageArr[language.rawValue]!.count) {
            return _LanguageArr[language.rawValue]![uniqueID]
        }
        return nil
    }
    
    static func GetCountID(language: LANGUAGE, lesson: Int) -> Int {
        
        if (_IDArr[language.rawValue] == nil) {
            GetArrayData(language)
        }
        return _IDArr[language.rawValue]![lesson]
    }
    
    static func SaveScript(language: LANGUAGE, scriptData: NSData) {
        DataIO.Write(SCRIPT_FILE_NAME[language.rawValue], data: scriptData)
    }
    
    static func ReadScript(language: LANGUAGE) -> NSData? {
        
        //var resultData: NSData? = nil
        var resultData = DataIO.Read(SCRIPT_FILE_NAME[language.rawValue])
        if (resultData == nil || !LeafConfig.LocalCache) {
            resultData = IUpdateScript(language)
        }
        
        return resultData
    }
    
    static func IUpdateScript(language: LANGUAGE) -> NSData? {
        
        var scriptData: NSData?
        let scriptURLPath = LeafConfig.GetURLPath(SCRIPT_FILE_NAME[language.rawValue])
        let connectionMgr = ConnectionManager()
        
        scriptData = connectionMgr.GetHttpData(scriptURLPath)
        SaveScript(language, scriptData: scriptData!)
        
        return scriptData
    }
    
    static func GetLessonCount(groupCount:Int) -> Int {
        return groupCount * _LessonCountOfGroup
    }
    
    static func GetVocabularyCount(language: LANGUAGE) -> Int {
        
        if (_LanguageArr[language.rawValue] == nil) {
            _LanguageArr[language.rawValue] = GetArrayData(language)
        }
        return _LanguageArr[language.rawValue]!.count
    }
    
    static func GetVocabularyCount(language: LANGUAGE, lesson: Int) -> Int {
        
        if (_IDArr[language.rawValue] == nil) {
            GetArrayData(language)
        }
        
        if (lesson == 0) {
            return _IDArr[language.rawValue]![lesson]
        }
        return _IDArr[language.rawValue]![lesson] - _IDArr[language.rawValue]![lesson - 1]
    }
    
    static func GetLessonCount(language: LANGUAGE) -> Int {
        
        if (_IDArr[language.rawValue] == nil) {
            GetArrayData(language)
        }
        return _IDArr[language.rawValue]!.count
    }
    
    static func GetLessonCount(language: LANGUAGE, GroupID: Int) -> Int {
        
        if (GroupID < GetGroupCount(language) - 1) {
            return _LessonCountOfGroup
        }
        return GetLessonCount(language) - _LessonCountOfGroup * GroupID
    }
    
    static func GetGroupCount(language: LANGUAGE) -> Int {
        
        var groupCount = GetLessonCount(language) / _LessonCountOfGroup
        if (GetLessonCount(language) % _LessonCountOfGroup != 0) {
            groupCount = groupCount + 1
        }
        return groupCount
    }
    
    static func GetLessonCountOfGroup() -> Int {
        return _LessonCountOfGroup
    }
}