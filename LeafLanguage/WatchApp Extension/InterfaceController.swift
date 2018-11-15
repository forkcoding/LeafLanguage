//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by LeafMaple on 2018/10/26.
//  Copyright © 2018 LeafMaple. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    fileprivate var _IndexArray = [Int]()
    fileprivate var _RandomIndex = 0
    fileprivate var _Vocabulary: Vocabulary?
    fileprivate var _GlosList: [ Any ]?

    @IBOutlet var MeaningLabel: WKInterfaceLabel!
    @IBOutlet var ExtVocLabel: WKInterfaceLabel!
    @IBOutlet var VocLabel: WKInterfaceLabel!
    @IBOutlet var NextButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        WatchSessionManager.sharedManager.startSession(self)
        WatchSessionManager.sharedManager.sendMessage(
            message: ["MSG" : "GetGlosVoc"]
        )
        NextButton.setHidden(true)
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async() {
            self._GlosList = message["Glos"] as! [Any]
            for list in self._GlosList! {
                var dictVoc = list as! [String : String]
                for (key, value) in dictVoc {
                    print(key, value)
                }
            }
            self.InitVocabulary()
        }
    }
    
    func InitVocabulary() {
        var randomArr = Array<Int>()
        
        for i in 0..._GlosList!.count - 1 {
            randomArr.append(i)
        }
        
        _IndexArray.removeAll()
        while (randomArr.count > 0) {
            
            let randomInt = Int(arc4random_uniform(UInt32(randomArr.count)))
            
            _IndexArray.append(randomArr[randomInt])
            randomArr.remove(at: randomInt)
        }
        
        UpdateVocabulary()
        NextButton.setHidden(false)
    }
    
    func UpdateVocabulary() {
        if (_RandomIndex < _IndexArray.count) {
            var glos: [String : String] = _GlosList![_IndexArray[_RandomIndex]] as! [String : String]
            
            VocLabel.setText(glos["Word"])
            ExtVocLabel.setText(glos["CNWord"])
            MeaningLabel.setText(glos["Meaning"])
        }
        
        if (_RandomIndex == _IndexArray.count - 1) {
            NextButton.setHidden(true)
        }
        else {
            NextButton.setHidden(false)
        }
    }

    @IBAction func UpdateNext() {
        
        if (_RandomIndex < _IndexArray.count - 1) {
            _RandomIndex = _RandomIndex + 1
            UpdateVocabulary()
        }
    }
}
