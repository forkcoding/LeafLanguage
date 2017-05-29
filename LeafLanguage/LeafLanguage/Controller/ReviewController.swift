//
//  ReviewController.swift
//  LeafLanguage
//
//  Created by LeafMaple on 16/6/26.
//  Copyright © 2016年 LeafMaple. All rights reserved.
//

import Foundation

class ReviewController : UIViewController {
    
    @IBOutlet weak var GlossaryCountLabel: UILabel!
    
    fileprivate var _GlossaryArray: NSMutableDictionary?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.blackOpaque
        self.navigationController!.navigationBar.tintColor = UIColor.white
        
        InitData()
        InitView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        UpdateData()
        UpdateView()
    }
    
    func InitData() {
        
        UpdateData()
        
    }
    
    func InitView() {
        
        GlossaryCountLabel.font = UIFont(name: "DBLCDTempBlack", size: 20.0)
        
        UpdateView()
    }
    
    func UpdateData() {
        
        if let glossaryModel = GlossaryModel.GetModel() {
            _GlossaryArray = NSMutableDictionary(dictionary: glossaryModel)
        }
        else {
            _GlossaryArray = NSMutableDictionary()
        }

    }
    
    func UpdateView() {
        
        GlossaryCountLabel.text = "\(_GlossaryArray!.count)"
    }
    
    @IBAction func GlossaryButtonClick(_ sender: AnyObject) {
        
    }
}
