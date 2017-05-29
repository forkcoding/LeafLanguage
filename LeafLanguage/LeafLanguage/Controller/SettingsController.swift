//
//  SecondViewController.swift
//  LeafLanguage
//
//  Created by LeafMaple on 15/5/24.
//  Copyright (c) 2015年 LeafMaple. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var AutoPlayButton: UIButton!
    @IBOutlet weak var CacheButton: UIButton!
    @IBOutlet weak var RandomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UpdateView()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func UpdateView() {
        
        UpdateAutoPlayView()
        UpdateCacheView()
        UpdateRandomVocView()
    }
    
    @IBAction func UpdateBtnClick(){
        
        VocabularyModel.IUpdateScript(LANGUAGE.japanese)
        
        let alert = UIAlertView(title: "更新完成", message: "数据已经完成更新！", delegate: self, cancelButtonTitle: "确定")
        alert.show()
    }
    
    @IBAction func AutoPlayClick(_ sender: AnyObject) {
        
        LeafConfig.AutoPlaySound = !LeafConfig.AutoPlaySound
        UpdateAutoPlayView()
    }
    @IBAction func CacheClick(_ sender: AnyObject) {
        
        LeafConfig.LocalCache = !LeafConfig.LocalCache
        UpdateCacheView()
    }
    @IBAction func RandomVocClick(_ sender: AnyObject) {
        
        LeafConfig.RandomVoc = !LeafConfig.RandomVoc
        UpdateRandomVocView()
    }
    
    func UpdateAutoPlayView() {
        
        if (LeafConfig.AutoPlaySound) {
            AutoPlayButton.setBackgroundImage(UIImage(named: "On"), for: UIControlState())
        }
        else {
            AutoPlayButton.setBackgroundImage(UIImage(named: "Off"), for: UIControlState())
        }
    }
    
    func UpdateCacheView() {
        
        if (LeafConfig.LocalCache) {
            CacheButton.setBackgroundImage(UIImage(named: "On"), for: UIControlState())
        }
        else {
            CacheButton.setBackgroundImage(UIImage(named: "Off"), for: UIControlState())
        }
    }
    
    func UpdateRandomVocView() {
        
        if (LeafConfig.RandomVoc) {
            RandomButton.setBackgroundImage(UIImage(named: "On"), for: UIControlState())
        }
        else {
            RandomButton.setBackgroundImage(UIImage(named: "Off"), for: UIControlState())
        }
    }
}

