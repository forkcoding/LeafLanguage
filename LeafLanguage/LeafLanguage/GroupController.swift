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
    
    private let TITLE_STRING = "课程选择"
    
    private var _GroupIndex = -1
    private var _Language = LANGUAGE.JAPANESE
    private var _StartLesson = -1
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem(title: TITLE_STRING, style: .Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        self.navigationItem.title = "第\(LeafConfig.ConvertToNumber(_GroupIndex + 1))单元"
        
        self.navigationController!.navigationBar.backgroundColor = UIColor.blackColor()
        
        //self.navigationItem.co
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VocabularyModel.GetLessonCount(_Language, GroupID: _GroupIndex) + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CellId")
        if (cell == nil) {
            cell = UITableViewCell(style:.Default, reuseIdentifier:"CellId")
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        if (indexPath.row == 0) {
            cell!.textLabel!.text = "全部单词"
        }
        else {
            cell!.textLabel!.text = "第\(LeafConfig.ConvertToNumber(indexPath.row + VocabularyModel.GetLessonCountOfGroup() * _GroupIndex))课"
        }
        
        cell!.textLabel!.textAlignment = NSTextAlignment.Center
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var startLs = 0
        var endLs = 0
        var startID = 0
        var endID = 0
        
        if (indexPath.row == 0) {
            startLs = _StartLesson
            endLs = _StartLesson + VocabularyModel.GetLessonCount(_Language, GroupID: _GroupIndex)
        }
        else {
            startLs = _StartLesson + indexPath.row - 1
            endLs = _StartLesson + indexPath.row
        }
        
        startID = VocabularyModel.GetCountID(_Language, lesson: startLs)
        if (endLs < VocabularyModel.GetLessonCount(_Language)) {
            endID = VocabularyModel.GetCountID(_Language, lesson: endLs)
        }
        else {
            endID = VocabularyModel.GetVocabularyCount(_Language)
        }
            
        let VocView = self.storyboard?.instantiateViewControllerWithIdentifier("WordView") as! VocabularyController
            
        VocView.SetVocabularyID(startID, endID: endID)
            
        self.navigationController?.pushViewController(VocView, animated: true)
        
    }
    
    func SetGroup(groupIndex:Int) {
        _GroupIndex = groupIndex
        _StartLesson = _GroupIndex * VocabularyModel.GetLessonCountOfGroup()
    }
    
    func SetLanguage(langue:LANGUAGE) {
        _Language = langue
    }
}