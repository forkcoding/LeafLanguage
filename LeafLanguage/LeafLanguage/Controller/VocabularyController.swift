//
//  MainViewController.swift
//  LeafLanguage
//
//  Created by LeafMaple on 15/5/26.
//  Copyright (c) 2015年 LeafMaple. All rights reserved.
//

import UIKit

class VocabularyController : UIViewController {
    
    fileprivate var _SelectedLanguage = LANGUAGE.japanese
    fileprivate var _SelectedGroup = -1
    fileprivate var _SelectedLesson = -1
    
    fileprivate var _StartID = -1
    fileprivate var _EndID = -1
    
    fileprivate var _GlossaryArray: NSMutableDictionary?
    
    fileprivate let END_STRING = "单词结束"
    
    fileprivate var _IndexArray = [Int]()
    fileprivate var _Vocabulary: Vocabulary?
    fileprivate var _RandomIndex = 0
    
    @IBOutlet weak var VocabularyLabel: UILabel!
    @IBOutlet weak var CountLabel: UILabel!
    @IBOutlet weak var ExtVocLabel: UILabel!
    @IBOutlet weak var MeaningLabel: UILabel!
    
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var ExtVocButton: UIButton!
    @IBOutlet weak var VocabularyButton: UIButton!
    @IBOutlet weak var MeaningButton: UIButton!
    
    fileprivate var _SoundManager: SoundManager?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        InitView()
        InitVocabulary()
        UpdateVocabulary()
        AddSwipeGesture()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if (_GlossaryArray != nil) {
            GlossaryModel.SetModel(_GlossaryArray!)
            GlossaryModel.SaveModel()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func UpdatePrev() {
        
        if (_RandomIndex > 0) {
            _RandomIndex = _RandomIndex - 1
            UpdateVocabulary()
        }
    }
    
    @IBAction func UpdateNext() {
        
        if (_RandomIndex < _IndexArray.count) {
            _RandomIndex = _RandomIndex + 1
            UpdateVocabulary()
        }
    }
    
    @IBAction func AddBtnClick() {
        
        if (_GlossaryArray == nil) {
            
            if let glossaryModel = GlossaryModel.GetModel() {
                _GlossaryArray = NSMutableDictionary(dictionary: glossaryModel)
            }
            else {
                _GlossaryArray = NSMutableDictionary()
            }
        }
        
        if (_Vocabulary != nil) {
            
            let StringID = String.init(_Vocabulary!.UniqueID)
            
            if (_GlossaryArray![StringID] == nil) {
                _GlossaryArray![StringID] = 1
            }
            else {
                _GlossaryArray![StringID] = _GlossaryArray![StringID] as! Int + 1
            }
            
            ToastManager.Show("已添加到生词表", timeOut: 2)
        }
    }
    
    @IBAction func SoundClick() {
        
        if (_SoundManager == nil) {
            _SoundManager = SoundManager()
        }
        
        if (_Vocabulary != nil) {
            _SoundManager!.Play(_Vocabulary!.SoundName,
                                startTime: _Vocabulary!.SoundStart,
                                endTime: _Vocabulary!.SoundEnd)
        }
    }
    
    @IBAction func ShowExtClick() {
        
        if (ExtVocLabel!.isHidden) {
            ExtVocLabel!.isHidden = false
            ExtVocButton.setBackgroundImage(UIImage(named: "ExtOn"), for: UIControlState())
        }
        else {
            ExtVocLabel!.isHidden = true
            ExtVocButton.setBackgroundImage(UIImage(named: "ExtOff"), for: UIControlState())
        }
    }
    
    @IBAction func ShowVocClick() {
        
        if (VocabularyLabel!.isHidden) {
            VocabularyLabel!.isHidden = false
            VocabularyButton.setBackgroundImage(UIImage(named: "JPNOn"), for: UIControlState())
        }
        else {
            VocabularyLabel!.isHidden = true
            VocabularyButton.setBackgroundImage(UIImage(named: "JPNOff"), for: UIControlState())
        }
    }
    
    @IBAction func ShowMeaningClick() {
        
        if (MeaningLabel!.isHidden) {
            MeaningLabel!.isHidden = false
            MeaningButton.setBackgroundImage(UIImage(named: "CNOn"), for: UIControlState())
        }
        else {
            MeaningLabel!.isHidden = true
            MeaningButton.setBackgroundImage(UIImage(named: "CNOff"), for: UIControlState())
        }
    }
    
    func InitView() {
        ExtVocLabel!.isHidden = true
        MeaningLabel!.isHidden = true
        
        MeaningLabel!.font = UIFont(name: "DBLCDTempBlack", size: 18.0)
        CountLabel!.font = UIFont(name: "DBLCDTempBlack", size: 20.0)
    }
    
    func InitVocabulary() {
        
        var randomArr = Array<Int>()
        
        for i in _StartID..._EndID - 1 {
            randomArr.append(i)
        }
        
        _IndexArray.removeAll()
        
        if (LeafConfig.RandomVoc) {
            while (randomArr.count > 0) {
                
                let randomInt = Int(arc4random_uniform(UInt32(randomArr.count)))
                
                _IndexArray.append(randomArr[randomInt])
                randomArr.remove(at: randomInt)
            }
        }
        else {
            _IndexArray = randomArr
        }
    }
    
    func UpdateVocabulary() {
        
        if (_RandomIndex < _IndexArray.count) {
            
            _Vocabulary = VocabularyModel.GetVocabulary(_SelectedLanguage, uniqueID: _IndexArray[_RandomIndex])
            
            VocabularyLabel!.text = _Vocabulary!.Word
            ExtVocLabel!.text = _Vocabulary!.CNWord
            MeaningLabel.text = _Vocabulary!.Meaning
            
            let indexString = NSString(format: "%03d", _RandomIndex + 1)
            let countString = NSString(format: "%03d", _IndexArray.count)
            
            CountLabel?.text = "\(indexString)/\(countString)"
        }
        
        NextButton.isEnabled = _RandomIndex < _IndexArray.count - 1
        
        if (LeafConfig.AutoPlaySound) {
            SoundClick()
        }
    }
    
    func SetVocabularyID(_ startID: Int, endID: Int) {
        _StartID = startID
        _EndID = endID
    }
    
    func AddSwipeGesture() {
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(VocabularyController.HandleSwipeGesture))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(VocabularyController.HandleSwipeGesture))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(rightSwipe)
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(VocabularyController.HandleSwipeGesture))
        upSwipe.numberOfTouchesRequired = 1
        upSwipe.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(VocabularyController.HandleSwipeGesture))
        downSwipe.numberOfTouchesRequired = 1
        downSwipe.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(downSwipe)
    }
    
    func HandleSwipeGesture(_ sender: UISwipeGestureRecognizer) {

        switch (sender.direction){
        case UISwipeGestureRecognizerDirection.left:
            UpdateNext()
            break
        case UISwipeGestureRecognizerDirection.right:
            UpdatePrev()
            break
        case UISwipeGestureRecognizerDirection.up:
            AddBtnClick()
            break
        case UISwipeGestureRecognizerDirection.down:
            SoundClick()
            break
        default:
            break;
        }
    }
}
