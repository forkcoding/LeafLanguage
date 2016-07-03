//
//  GlossaryController.swift
//  LeafLanguage
//
//  Created by LeafMaple on 16/6/26.
//  Copyright © 2016年 LeafMaple. All rights reserved.
//

import Foundation

class GlossaryController : UIViewController {
    
    private var _SelectedLanguage = LANGUAGE.JAPANESE
    
    private var _GlossaryArray: NSMutableDictionary?
    private var _GlossaryIndexArray = [Int]()
    
    private let END_STRING = "单词结束"
    
    private var _IndexArray = [Int]()
    private var _Vocabulary: Vocabulary?
    private var _RandomIndex = 0
    
    @IBOutlet weak var VocabularyLabel: UILabel!
    @IBOutlet weak var CountLabel: UILabel!
    @IBOutlet weak var ExtVocLabel: UILabel!
    @IBOutlet weak var MeaningLabel: UILabel!
    
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var ExtVocButton: UIButton!
    @IBOutlet weak var VocabularyButton: UIButton!
    @IBOutlet weak var MeaningButton: UIButton!
    @IBOutlet weak var HardNumLabel: UILabel!
    
    private var _SoundManager: SoundManager?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        InitView()
        InitVocabulary()
        UpdateVocabulary()
        AddSwipeGesture()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
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
        
        if (_RandomIndex < _IndexArray.count - 1) {
            _RandomIndex = _RandomIndex + 1
        }
        UpdateVocabulary()
        
    }
    
    @IBAction func addBtnClick() {
        
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
        }
    }
    
    @IBAction func soundClick() {
        
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
        
        if (ExtVocLabel!.hidden) {
            ExtVocLabel!.hidden = false
            //ExtVocButton.setTitle("隐藏汉字", forState: UIControlState.Normal)
            ExtVocButton.setBackgroundImage(UIImage(named: "ExtOn"), forState: UIControlState.Normal)
        }
        else {
            ExtVocLabel!.hidden = true
            ExtVocButton.setBackgroundImage(UIImage(named: "ExtOff"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func ShowVocClick() {
        
        if (VocabularyLabel!.hidden) {
            VocabularyLabel!.hidden = false
            VocabularyButton.setBackgroundImage(UIImage(named: "JPNOn"), forState: UIControlState.Normal)
        }
        else {
            VocabularyLabel!.hidden = true
            VocabularyButton.setBackgroundImage(UIImage(named: "JPNOff"), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func ShowMeaningClick() {
        
        if (MeaningLabel.hidden) {
            MeaningLabel.hidden = false
            MeaningButton.setBackgroundImage(UIImage(named: "CNOn"), forState: UIControlState.Normal)
        }
        else {
            MeaningLabel.hidden = true
            MeaningButton.setBackgroundImage(UIImage(named: "CNOff"), forState: UIControlState.Normal)
        }
    }
    
    func InitView() {
        ExtVocLabel.hidden = true
        MeaningLabel.hidden = true
        
        MeaningLabel.font = UIFont(name: "DBLCDTempBlack", size: 18.0)!
        CountLabel.font = UIFont(name: "DBLCDTempBlack", size: 20.0)
        HardNumLabel.font = UIFont(name: "DBLCDTempBlack", size: 20.0)
    }
    
    func InitVocabulary() {
        
        var randomArr = Array<Int>()
        
        if let glossaryModel = GlossaryModel.GetModel() {
            _GlossaryArray = NSMutableDictionary(dictionary: glossaryModel)
        }
        else {
            _GlossaryArray = NSMutableDictionary()
        }
        
        for i in 0..._GlossaryArray!.count - 1 {
            randomArr.append(i)
        }
        
        _GlossaryIndexArray.removeAll()
        for key in _GlossaryArray!.keyEnumerator() {
            _GlossaryIndexArray.append(Int(key as! String)!)
        }
        
        _IndexArray.removeAll()
        
        if (LeafConfig.RandomVoc) {
            while (randomArr.count > 0) {
                
                let randomInt = Int(arc4random_uniform(UInt32(randomArr.count)))
                
                _IndexArray.append(randomArr[randomInt])
                randomArr.removeAtIndex(randomInt)
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
            
            let StringID = String.init(_Vocabulary!.UniqueID)
            
            HardNumLabel.text = "\(_GlossaryArray![StringID] as! Int)"
        }
        
        if (_RandomIndex == _IndexArray.count - 1) {
            NextButton.enabled = false
        }
        else {
            NextButton.enabled = true
        }
        
        if (LeafConfig.AutoPlaySound) {
            soundClick()
        }
    }
    
    func AddSwipeGesture() {
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(VocabularyController.HandleSwipeGesture))
        leftSwipe.numberOfTouchesRequired = 1
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(VocabularyController.HandleSwipeGesture))
        rightSwipe.numberOfTouchesRequired = 1
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    func HandleSwipeGesture(sender: UISwipeGestureRecognizer) {
        
        switch (sender.direction){
        case UISwipeGestureRecognizerDirection.Left:
            UpdateNext()
            break
        case UISwipeGestureRecognizerDirection.Right:
            UpdatePrev()
            break
        default:
            break;
        }
    }

    
}