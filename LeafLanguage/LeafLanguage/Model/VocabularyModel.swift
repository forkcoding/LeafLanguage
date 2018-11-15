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
    
    static fileprivate var _VocArrs = Array<Array<Vocabulary>?>(repeating: nil, count: SCRIPT_FILE_NAME.count)
    static fileprivate var _CountsArr = Array<Array<Int>?>(repeating: nil, count: SCRIPT_FILE_NAME.count)
    
    static func UpdateVocArr(_ language: LANGUAGE) {
        
        var vocArr = Array<Vocabulary>()
        var countArr = Array<Int>()
        
        let scriptData = ReadScript(language)
        
        do {
            let jsonScript = try JSONSerialization.jsonObject(with: scriptData!, options: JSONSerialization.ReadingOptions.allowFragments)
            
            let scriptArr = jsonScript as! NSArray
            
            for (lsId, lsObj) in scriptArr.enumerated() {
                
                let soundFileName = (NSString(format: "%03d", language.rawValue) as String)
                    + (NSString(format: "%03d", lsId + 1) as String)
                
                let lsArray = lsObj as! NSArray
                
                countArr.append(vocArr.count)
                
                for vocObj in lsArray {
                    
                    let vocStr = (vocObj as AnyObject).object(forKey: "Voc") as! String
                    let extStr = (vocObj as AnyObject).object(forKey: "Ext") as! String
                    let typeStr = (vocObj as AnyObject).object(forKey: "Type") as! String
                    let meaningStr = (vocObj as AnyObject).object(forKey: "Meaning") as! String
                    let uniqueID = vocArr.count
                    
                    var startTime = 0.0
                    
                    let timeObj = (vocObj as AnyObject).object(forKey: "Time")
                    if (timeObj != nil) {
                        startTime = timeObj as! Double
                    }
                    
                    if (uniqueID > 0) {
                        vocArr[uniqueID - 1].SoundEnd = startTime
                    }
                    
                    vocArr.append(Vocabulary(
                        Word:       vocStr,         CNWord:     extStr,
                        WordType:   typeStr,        Meaning:    meaningStr,
                        SoundName:  soundFileName,  SoundStart: startTime,
                        SoundEnd:   0.0,            UniqueID:   uniqueID))
                    
                }
            }
            
            _CountsArr[language.rawValue] = countArr
            _VocArrs[language.rawValue] = vocArr
        } catch {
            _CountsArr[language.rawValue] = countArr
            _VocArrs[language.rawValue] = Array<Vocabulary>()
        }
    }
    
    static func GetVocabulary(_ language: LANGUAGE, uniqueID: Int) -> Vocabulary? {
        
        if (_VocArrs[language.rawValue] == nil) {
            UpdateVocArr(language)
        }
        
        if (uniqueID < _VocArrs[language.rawValue]!.count) {
            return _VocArrs[language.rawValue]![uniqueID]
        }
        return nil
    }
    
    static func GetCountID(_ language: LANGUAGE, lesson: Int) -> Int {
        
        if (_CountsArr[language.rawValue] == nil) {
            UpdateVocArr(language)
        }
        return _CountsArr[language.rawValue]![lesson]
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
        
        if (_VocArrs[language.rawValue] == nil) {
            UpdateVocArr(language)
        }
        return _VocArrs[language.rawValue]!.count
    }
    
    static func GetVocabularyCount(_ language: LANGUAGE, lesson: Int) -> Int {
        
        if (_CountsArr[language.rawValue] == nil) {
            UpdateVocArr(language)
        }
        
        if (lesson == 0) {
            return _CountsArr[language.rawValue]![lesson]
        }
        return _CountsArr[language.rawValue]![lesson] - _CountsArr[language.rawValue]![lesson - 1]
    }
    
    static func GetLessonCount(_ language: LANGUAGE) -> Int {
        
        if (_CountsArr[language.rawValue] == nil) {
            UpdateVocArr(language)
        }
        return _CountsArr[language.rawValue]!.count
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
