//
//  SoundManage.swift
//  LeafLanguage
//
//  Created by LeafMaple on 15/6/4.
//  Copyright (c) 2015年 LeafMaple. All rights reserved.
//

import UIKit
import AVFoundation

class SoundManager : NSObject {
    
    fileprivate let SOUND_PATH = "sound"
    
    fileprivate var _AudioPlayer: AVAudioPlayer?
    fileprivate var _PlayerTimer: Timer?
    
    func PlayEndFunc() {
        _AudioPlayer!.stop()
    }
    
    func Play(_ fileName: String, startTime: Double, endTime: Double) {
        
        if (_AudioPlayer != nil && _AudioPlayer!.isPlaying == true) {
            _AudioPlayer!.stop()
        }
        
        if (_PlayerTimer != nil) {
            _PlayerTimer!.fire()
        }
        
        let soundData = GetSound(fileName)
        
        _AudioPlayer = try! AVAudioPlayer(data: soundData!)
        
        if (_AudioPlayer == nil) { return }
        
        _AudioPlayer!.currentTime = startTime
        _AudioPlayer!.prepareToPlay()
        
        if (endTime > startTime) {
            
            _PlayerTimer = Timer.scheduledTimer(timeInterval: endTime - startTime, target: self, selector: #selector(SoundManager.PlayEndFunc), userInfo: nil, repeats: false)
            
        }
        
        _AudioPlayer!.play()
        
    }
    
    func Play(_ startTime: Double, endTime: Double) {
        
        if (_AudioPlayer != nil && _AudioPlayer!.isPlaying == true) {
            _AudioPlayer!.stop()
        }
        
        _AudioPlayer!.numberOfLoops = 1
        _AudioPlayer!.currentTime = startTime
        _AudioPlayer!.prepareToPlay()
        
        _PlayerTimer = Timer.scheduledTimer(timeInterval: endTime - startTime, target:self, selector: #selector(SoundManager.PlayEndFunc), userInfo:nil, repeats: false)
        
    }
    
    func GetSound(_ fileName: String) -> Data? {
        
        let soundPath = LeafConfig.ConvertToPath(fileName, fileType: "mp3", directory: SOUND_PATH)
        var soundData = DataIO.Read(soundPath)
        
        if (soundData == nil || !LeafConfig.LocalCache) {
            soundData = UpdateSound(soundPath)
        }
        
        return soundData
    }
    
    func SaveSound(_ soundPath: String, soundData: Data) {
        
        DataIO.CreateDirectory(SOUND_PATH)
        DataIO.Write(soundPath, data: soundData)
    }
    
    func UpdateSound(_ soundPath: String) -> Data? {
        
        let connectionMgr = ConnectionManager()
        let soundURLPath = LeafConfig.GetURLPath(soundPath)
        let soundData = connectionMgr.GetHttpData(soundURLPath)
        
        SaveSound(soundPath, soundData: soundData!)
        
        return soundData
        
    }
}
