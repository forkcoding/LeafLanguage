//
//  LeafConfig.swift
//  LeafLanguage
//
//  Created by LeafMaple on 15/6/1.
//  Copyright (c) 2015年 LeafMaple. All rights reserved.
//

import Foundation

struct Vocabulary {
    var Word: String
    var CNWord: String
    var WordType: String
    var Meaning: String
    var SoundName: String
    var SoundStart: Double
    var SoundEnd: Double
    var UniqueID: Int
}

enum LANGUAGE: Int {
    case JAPANESE = 0
    case ENGLISH
}

class LeafConfig {
    
    static let INTERNET_PATH = "http://leafvmaple.github.io/script"
    
    static let NUMBER_STRING = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "百"]
    
    static var AutoPlaySound = false
    static var LocalCache = true
    static var RandomVoc = true
    
    static func ConvertToNumber(number: Int) -> String {
        
        var resultString = String()
        var numberValue = number
        
        while(numberValue > 0) {
            
            if (numberValue > 99) {
                let hundreds = numberValue / 100
                resultString += NUMBER_STRING[hundreds] + NUMBER_STRING[11]
                
                if (numberValue == 100) {}
                else if (numberValue < 110) {
                    resultString += NUMBER_STRING[0]
                }
                else if (numberValue < 120) {
                    resultString += NUMBER_STRING[1]
                }
                
                numberValue -= hundreds * 100
            }
            else if (numberValue > 19) {
                let tens = numberValue / 10
                resultString += NUMBER_STRING[tens]
                numberValue -= (tens - 1) * 10
            }
            else if (numberValue > 9) {
                resultString += NUMBER_STRING[10]
                numberValue -= 10
            }
            else {
                resultString += NUMBER_STRING[numberValue]
                numberValue = 0
            }
        }
        
        return resultString
    }
    
    static func ConvertToPath(fileName: String, fileType: String, directory: String) -> String {
        return directory + "/" + fileName + "." + fileType
    }
    
    static func GetURLPath(fileName: String) -> String {
        return INTERNET_PATH + "/" + fileName
    }
}