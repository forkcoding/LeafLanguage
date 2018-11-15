//
//  GroupController.swift
//  LeafLanguage
//
//  Created by LeafMaple on 15/5/30.
//  Copyright (c) 2015年 LeafMaple. All rights reserved.
//

import UIKit

class GroupController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var m_tableView: UITableView?
    
    fileprivate let TITLE_STRING = "课程选择"
    
    fileprivate var _Language = LANGUAGE.japanese
    fileprivate var _GroupIndex = -1
    fileprivate var _StartLesson = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Thread.sleep(forTimeInterval: 3.0) // 延长3秒
        
        let backItem = UIBarButtonItem(title: TITLE_STRING, style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationItem.title = "第\(LeafConfig.ConvertToNumber(_GroupIndex + 1))单元"
        
        self.navigationController!.navigationBar.backgroundColor = UIColor.black
        
        //self.navigationItem.co
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VocabularyModel.GetLessonCount(_Language, GroupID: _GroupIndex) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellId")
        if (cell == nil) {
            cell = UITableViewCell(style:.default, reuseIdentifier:"CellId")
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        if ((indexPath as NSIndexPath).row == 0) {
            cell!.textLabel!.text = "全部单词"
        }
        else {
            cell!.textLabel!.text = "第\(LeafConfig.ConvertToNumber((indexPath as NSIndexPath).row + VocabularyModel.GetLessonCountOfGroup() * _GroupIndex))课"
        }
        
        cell!.textLabel!.textAlignment = NSTextAlignment.center
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var startLs = 0
        var endLs = 0
        var startID = 0
        var endID = 0
        
        if ((indexPath as NSIndexPath).row == 0) {
            startLs = _StartLesson
            endLs = _StartLesson + VocabularyModel.GetLessonCount(_Language, GroupID: _GroupIndex)
        }
        else {
            startLs = _StartLesson + (indexPath as NSIndexPath).row - 1
            endLs = _StartLesson + (indexPath as NSIndexPath).row
        }
        
        startID = VocabularyModel.GetCountID(_Language, lesson: startLs)
        if (endLs < VocabularyModel.GetLessonCount(_Language)) {
            endID = VocabularyModel.GetCountID(_Language, lesson: endLs)
        }
        else {
            endID = VocabularyModel.GetVocabularyCount(_Language)
        }
            
        let VocView = self.storyboard?.instantiateViewController(withIdentifier: "WordView") as! VocabularyController
        
        VocView.SetLanguage(_Language)
        VocView.SetVocabularyID(startID, endID: endID)
            
        self.navigationController?.pushViewController(VocView, animated: true)
        
    }
    
    func SetLanguage(_ langue:LANGUAGE) {
        _Language = langue
    }
    func SetGroup(_ groupIndex:Int) {
        _GroupIndex = groupIndex
        _StartLesson = _GroupIndex * VocabularyModel.GetLessonCountOfGroup()
    }
}
