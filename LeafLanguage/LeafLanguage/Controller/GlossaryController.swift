//
//  GlossaryController.swift
//  LeafLanguage
//
//  Created by LeafMaple on 16/6/26.
//  Copyright © 2016年 LeafMaple. All rights reserved.
//

import Foundation

class GlossaryController : UIViewController, UIActionSheetDelegate {
    fileprivate let ENDING_STRING = "单词结束"
    
    fileprivate var selectedLang = LANGUAGE.japanese
    fileprivate var arrGlosIndex = [Int]()
    fileprivate var arrIndex = [Int]()
    fileprivate var vocabulary: Vocabulary?
    fileprivate var randIndex = 0
    
    @IBOutlet weak var VocabularyLabel: UILabel!
    @IBOutlet weak var CountLabel: UILabel!
    @IBOutlet weak var ExtVocLabel: UILabel!
    @IBOutlet weak var MeaningLabel: UILabel!
    
    @IBOutlet weak var NextButton: UIButton!
    @IBOutlet weak var ExtVocButton: UIButton!
    @IBOutlet weak var VocabularyButton: UIButton!
    @IBOutlet weak var MeaningButton: UIButton!
    @IBOutlet weak var HardNumLabel: UILabel!
    
    fileprivate var soundManager: SoundManager?
    
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
        if (randIndex > 0) {
            randIndex = randIndex - 1
            UpdateVocabulary()
        }
    }
    
    @IBAction func UpdateNext() {
        if (randIndex < arrIndex.count - 1) {
            randIndex = randIndex + 1
            UpdateVocabulary()
        }
    }
    
    @IBAction func AddBtnClick() {
        if (vocabulary != nil) {
            let id = String.init(vocabulary!.UniqueID)
            GlossaryModel.Add(key: id, num: 1)
            UpdateVocabulary()
        }
    }
    
    @IBAction func SoundClick() {
        if (soundManager == nil) {
            soundManager = SoundManager()
        }
        
        if (vocabulary != nil) {
            soundManager!.Play(vocabulary!.SoundName, startTime: vocabulary!.SoundStart, endTime: vocabulary!.SoundEnd)
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
            let id = String.init(vocabulary!.UniqueID)
            GlossaryModel.Remove(key: id)
            arrIndex.remove(at: randIndex)
            if (randIndex >= arrIndex.count){
                randIndex = randIndex - 1
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
        
        arrGlosIndex.removeAll()
        for key in GlossaryModel.Enumerator() {
            arrGlosIndex.append(Int(key as! String)!)
        }
        
        arrIndex.removeAll()
        
        if (LeafConfig.RandomVoc) {
            while (randomArr.count > 0) {
                
                let randomInt = Int(arc4random_uniform(UInt32(randomArr.count)))
                
                arrIndex.append(randomArr[randomInt])
                randomArr.remove(at: randomInt)
            }
        }
        else {
            arrIndex = randomArr
        }

    }
    
    func UpdateVocabulary() {
        
        if (randIndex < arrIndex.count) {
            
            vocabulary = VocabularyModel.GetVocabulary(selectedLang, uniqueID: arrGlosIndex[arrIndex[randIndex]])
            
            VocabularyLabel.text = vocabulary!.Word
            ExtVocLabel.text = vocabulary!.CNWord
            MeaningLabel.text = vocabulary!.Meaning
            
            let indexString = NSString(format: "%03d", randIndex + 1)
            let countString = NSString(format: "%03d", arrIndex.count)
            
            CountLabel.text = "\(indexString)/\(countString)"
            
            let id = String.init(vocabulary!.UniqueID)
            HardNumLabel.text = "\(GlossaryModel.Get(key: id))"
        }
        
        if (randIndex == arrIndex.count - 1) {
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
