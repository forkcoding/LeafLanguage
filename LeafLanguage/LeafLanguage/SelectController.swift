//
//  FirstViewController.swift
//  LeafLanguage
//
//  Created by LeafMaple on 15/5/24.
//  Copyright (c) 2015年 LeafMaple. All rights reserved.
//

import UIKit

class SelectController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var TableView: UITableView?
    
    private let TITLE_STRING = "单元选择"
    
    private var _Language = LANGUAGE.JAPANESE
    
    private var lessonArray: NSArray?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem(title: TITLE_STRING, style: .Done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        
        //self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.barStyle = UIBarStyle.BlackOpaque
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationController!.navigationBar.backgroundColor = UIColor.init(colorLiteralRed: <#T##Float#>, green: <#T##Float#>, blue: <#T##Float#>, alpha: <#T##Float#>)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  VocabularyModel.GetGroupCount(_Language) + 1
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CellId") as UITableViewCell?
        if (cell == nil) {
            cell = UITableViewCell(style:.Default, reuseIdentifier:"CellId")
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        if (indexPath.row == 0) {
            cell!.textLabel!.text = "全部单词"
        }
        else {
            cell!.textLabel!.text = "第\(LeafConfig.ConvertToNumber(indexPath.row))单元"
        }
        
        cell!.textLabel!.textAlignment = NSTextAlignment.Center
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let groupID = indexPath.row - 1
        
        if (groupID == -1) {
            
            let VocView = self.storyboard?.instantiateViewControllerWithIdentifier("WordView") as! VocabularyController
            
            VocView.SetVocabularyID(0, endID: VocabularyModel.GetVocabularyCount(_Language))
            
            self.navigationController?.pushViewController(VocView, animated: true)
            
        }
        else {
            let GroupView = self.storyboard?.instantiateViewControllerWithIdentifier("GroupView") as! GroupController
            
            GroupView.SetGroup(groupID)
            GroupView.SetLanguage(_Language)
            
            self.navigationController?.pushViewController(GroupView, animated: true)
            
        }
        
    }
    
    @IBAction func SegmentClick(sender: UISegmentedControl){
        
        let selectedIndex = sender.selectedSegmentIndex
        
        _Language = LANGUAGE(rawValue: selectedIndex)!
        
        TableView?.reloadData()
    }
}

