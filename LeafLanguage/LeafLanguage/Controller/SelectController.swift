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
    
    fileprivate let TITLE_STRING = "单元选择"
    
    fileprivate var _Language = LANGUAGE.japanese
    
    fileprivate var lessonArray: NSArray?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem(title: TITLE_STRING, style: .done, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
        
        //self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.barStyle = UIBarStyle.blackOpaque
        self.navigationController!.navigationBar.tintColor = UIColor.white
        //self.navigationController!.navigationBar.backgroundColor = UIColor.init(colorLiteralRed: <#T##Float#>, green: <#T##Float#>, blue: <#T##Float#>, alpha: <#T##Float#>)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  VocabularyModel.GetGroupCount(_Language) + 1
    }
    
    func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CellId") as UITableViewCell?
        if (cell == nil) {
            cell = UITableViewCell(style:.default, reuseIdentifier:"CellId")
        }
        
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        if ((indexPath as NSIndexPath).row == 0) {
            cell!.textLabel!.text = "全部单词"
        }
        else {
            cell!.textLabel!.text = "第\(LeafConfig.ConvertToNumber((indexPath as NSIndexPath).row))单元"
        }
        
        cell!.textLabel!.textAlignment = NSTextAlignment.center
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let groupID = (indexPath as NSIndexPath).row - 1
        
        if (groupID == -1) {
            
            let VocView = self.storyboard?.instantiateViewController(withIdentifier: "WordView") as! VocabularyController
            
            VocView.SetVocabularyID(0, endID: VocabularyModel.GetVocabularyCount(_Language))
            
            self.navigationController?.pushViewController(VocView, animated: true)
            
        }
        else {
            let GroupView = self.storyboard?.instantiateViewController(withIdentifier: "GroupView") as! GroupController
            
            GroupView.SetLanguage(_Language)
            GroupView.SetGroup(groupID)
            
            self.navigationController?.pushViewController(GroupView, animated: true)
            
        }
        
    }
    
    @IBAction func SegmentClick(_ sender: UISegmentedControl){
        
        let selectedIndex = sender.selectedSegmentIndex
        
        _Language = LANGUAGE(rawValue: selectedIndex)!
        
        TableView?.reloadData()
    }
}

