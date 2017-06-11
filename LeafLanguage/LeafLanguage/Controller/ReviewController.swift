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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.barStyle = UIBarStyle.blackOpaque
        self.navigationController!.navigationBar.tintColor = UIColor.white
        InitView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UpdateView()
    }
    
    func InitView() {
        GlossaryCountLabel.font = UIFont(name: "DBLCDTempBlack", size: 20.0)
        UpdateView()
    }
    
    func UpdateView() {
        GlossaryCountLabel.text = "\(GlossaryModel.Count())"
    }
    
    @IBAction func GlossaryButtonClick(_ sender: AnyObject) {
        
    }
}
