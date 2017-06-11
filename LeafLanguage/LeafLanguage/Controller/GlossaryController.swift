//
//  GlossaryController.swift
//  LeafLanguage
//
//  Created by LeafMaple on 16/6/26.
//  Copyright © 2016年 LeafMaple. All rights reserved.
//

import Foundation

class GlossaryController : UIViewController, UIActionSheetDelegate {
    
    fileprivate var _SelectedLanguage = LANGUAGE.japanese
    
    fileprivate var _GlossaryIndexArray = [Int]()
    
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
    @IBOutlet weak var HardNumLabel: UILabel!
    
    fileprivate var _SoundManager: SoundManager?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        InitView()
        InitVocabulary()
        UpdateVocabulary()
        AddSwipeGesture()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        GlossaryModel.SaveModel()
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
        
        if (_RandomIndex < _IndexArray.count - 1) {
            _RandomIndex = _RandomIndex + 1
            UpdateVocabulary()
        }
    }
    
    @IBAction func AddBtnClick() {
        if (_Vocabulary != nil) {
            let id = String.init(_Vocabulary!.UniqueID)
            GlossaryModel.Add(key: id, num: 1)
            UpdateVocabulary()
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
        
        if (MeaningLabel.isHidden) {
            MeaningLabel.isHidden = false
            MeaningButton.setBackgroundImage(UIImage(named: "CNOn"), for: UIControlState())
        }
        else {
            MeaningLabel.isHidden = true
            MeaningButton.setBackgroundImage(UIImage(named: "CNOff"), for: UIControlState())
        }
    }
    
    @IBAction func ShowMenuClick(_ sender: AnyObject) {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "删除")
        
        actionSheet.show(in: self.view)
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if (buttonIndex == 0) {
            let id = String.init(_Vocabulary!.UniqueID)
            GlossaryModel.Remove(key: id)
            _IndexArray.remove(at: _RandomIndex)
            if (_RandomIndex >= _IndexArray.count){
                _RandomIndex = _RandomIndex - 1
            }
            UpdateVocabulary()
        }
    }
    
    func InitView() {
        ExtVocLabel.isHidden = true
        MeaningLabel.isHidden = true
        
        MeaningLabel.font = UIFont(name: "DBLCDTempBlack", size: 18.0)!
        CountLabel.font = UIFont(name: "DBLCDTempBlack", size: 20.0)
        HardNumLabel.font = UIFont(name: "DBLCDTempBlack", size: 20.0)
    }
    
    func InitVocabulary() {
        var randomArr = Array<Int>()
        
        for i in 0...GlossaryModel.Count() - 1 {
            randomArr.append(i)
        }
        
        _GlossaryIndexArray.removeAll()
        for key in GlossaryModel.Enumerator() {
            _GlossaryIndexArray.append(Int(key as! String)!)
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
            
            _Vocabulary = VocabularyModel.GetVocabulary(_SelectedLanguage, uniqueID: _GlossaryIndexArray[_IndexArray[_RandomIndex]])
            
            VocabularyLabel.text = _Vocabulary!.Word
            ExtVocLabel.text = _Vocabulary!.CNWord
            MeaningLabel.text = _Vocabulary!.Meaning
            
            let indexString = NSString(format: "%03d", _RandomIndex + 1)
            let countString = NSString(format: "%03d", _IndexArray.count)
            
            CountLabel.text = "\(indexString)/\(countString)"
            
            let id = String.init(_Vocabulary!.UniqueID)
            HardNumLabel.text = "\(GlossaryModel.Get(key: id))"
        }
        
        if (_RandomIndex == _IndexArray.count - 1) {
            NextButton.isEnabled = false
        }
        else {
            NextButton.isEnabled = true
        }
        
        if (LeafConfig.AutoPlaySound) {
            SoundClick()
        }
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
