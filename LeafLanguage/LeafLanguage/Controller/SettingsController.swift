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
        AutoPlayButton.setBackgroundImage(UIImage(named: LeafConfig.AutoPlaySound ? "On" : "Off"), for: UIControlState())
    }
    
    func UpdateCacheView() {
        CacheButton.setBackgroundImage(UIImage(named: LeafConfig.LocalCache ? "On" : "Off"), for: UIControlState())
    }
    
    func UpdateRandomVocView() {
        RandomButton.setBackgroundImage(UIImage(named: LeafConfig.RandomVoc ? "On" : "Off"), for: UIControlState())
    }
}

