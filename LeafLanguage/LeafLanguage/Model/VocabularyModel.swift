//
//  VocabularyModel.swift
//  LeafLanguage
//
//  Created by LeafMaple on 16/6/15.
//  Copyright © 2016年 LeafMaple. All rights reserved.
//

import Foundation

class VocabularyModel {
    
    static fileprivate let _LessonCountOfGroup = 8
    static fileprivate var _Vocabulary: Array<Vocabulary>?
    
    static let LANGUAGE_STRING = ["Japanese", "English"]
    static fileprivate let SCRIPT_FILE_NAME = ["Japanese.json", "English.json"]
    
    static fileprivate var _LanguageArr = Array<Array<Vocabulary>?>(repeating: nil, count: SCRIPT_FILE_NAME.count)
    static fileprivate var _IDArr = Array<Array<Int>?>(repeating: nil, count: SCRIPT_FILE_NAME.count)
    
    static func GetArrayData(_ language: LANGUAGE) -> Array<Vocabulary> {
        
        var resultArr = Array<Vocabulary>()
        var lsIDArr = Array<Int>()
        
        let scriptData = ReadScript(language)
        
        do {
            let jsonScript = try JSONSerialization.jsonObject(with: scriptData!, options: JSONSerialization.ReadingOptions.allowFragments)
            
            let scriptArr = jsonScript as! NSArray
            
            for (lsId, lsObj) in scriptArr.enumerated() {
                
                let soundFileName = (NSString(format: "%03d", language.rawValue) as String)
                    + (NSString(format: "%03d", lsId + 1) as String)
                
                let lsArray = lsObj as! NSArray
                
                lsIDArr.append(resultArr.count)
                
                for vocObj in lsArray {
                    
                    let vocStr = (vocObj as AnyObject).object(forKey: "Voc") as! String
                    let extStr = (vocObj as AnyObject).object(forKey: "Ext") as! String
                    let typeStr = (vocObj as AnyObject).object(forKey: "Type") as! String
                    let meaningStr = (vocObj as AnyObject).object(forKey: "Meaning") as! String
                    let uniqueID = resultArr.count
                    
                    var startTime = 0.0
                    
                    let timeObj = (vocObj as AnyObject).object(forKey: "Time")
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
        } catch {
            _IDArr[language.rawValue] = lsIDArr
            return Array<Vocabulary>()
        }
    }
    
    static func GetVocabulary(_ language: LANGUAGE, uniqueID: Int) -> Vocabulary? {
        
        if (_LanguageArr[language.rawValue] == nil) {
            _LanguageArr[language.rawValue] = GetArrayData(language)
        }
        
        if (uniqueID < _LanguageArr[language.rawValue]!.count) {
            return _LanguageArr[language.rawValue]![uniqueID]
        }
        return nil
    }
    
    static func GetCountID(_ language: LANGUAGE, lesson: Int) -> Int {
        
        if (_IDArr[language.rawValue] == nil) {
            GetArrayData(language)
        }
        return _IDArr[language.rawValue]![lesson]
    }
    
    static func SaveScript(_ language: LANGUAGE, scriptData: Data) {
        DataIO.Write(SCRIPT_FILE_NAME[language.rawValue], data: scriptData)
    }
    
    static func ReadScript(_ language: LANGUAGE) -> Data? {
        
        //var resultData: NSData? = nil
        var resultData = DataIO.Read(SCRIPT_FILE_NAME[language.rawValue])
        if (resultData == nil || !LeafConfig.LocalCache) {
            resultData = IUpdateScript(language)
        }
        
        return resultData
    }
    
    static func IUpdateScript(_ language: LANGUAGE) -> Data? {
        
        var scriptData: Data?
        let scriptURLPath = LeafConfig.GetURLPath(SCRIPT_FILE_NAME[language.rawValue])
        let connectionMgr = ConnectionManager()
        
        scriptData = connectionMgr.GetHttpData(scriptURLPath)
        SaveScript(language, scriptData: scriptData!)
        
        return scriptData
    }
    
    static func GetLessonCount(_ groupCount:Int) -> Int {
        return groupCount * _LessonCountOfGroup
    }
    
    static func GetVocabularyCount(_ language: LANGUAGE) -> Int {
        
        if (_LanguageArr[language.rawValue] == nil) {
            _LanguageArr[language.rawValue] = GetArrayData(language)
        }
        return _LanguageArr[language.rawValue]!.count
    }
    
    static func GetVocabularyCount(_ language: LANGUAGE, lesson: Int) -> Int {
        
        if (_IDArr[language.rawValue] == nil) {
            GetArrayData(language)
        }
        
        if (lesson == 0) {
            return _IDArr[language.rawValue]![lesson]
        }
        return _IDArr[language.rawValue]![lesson] - _IDArr[language.rawValue]![lesson - 1]
    }
    
    static func GetLessonCount(_ language: LANGUAGE) -> Int {
        
        if (_IDArr[language.rawValue] == nil) {
            GetArrayData(language)
        }
        return _IDArr[language.rawValue]!.count
    }
    
    static func GetLessonCount(_ language: LANGUAGE, GroupID: Int) -> Int {
        
        if (GroupID < GetGroupCount(language) - 1) {
            return _LessonCountOfGroup
        }
        return GetLessonCount(language) - _LessonCountOfGroup * GroupID
    }
    
    static func GetGroupCount(_ language: LANGUAGE) -> Int {
        
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
