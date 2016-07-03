//
//  ToastManager.swift
//  LeafLanguage
//
//  Created by LeafMaple on 16/6/27.
//  Copyright © 2016年 LeafMaple. All rights reserved.
//

import Foundation

class ToastManager {
    
    private static var _ProgressHUD: MBProgressHUD?
    
    static func Show(text: String?, timeOut: UInt32) {
        
        let viewController = ViewModel.GetActiveController()
        
        _ProgressHUD = MBProgressHUD.showHUDAddedTo(viewController!.view, animated: true)
        
        if (_ProgressHUD != nil) {
            _ProgressHUD!.mode = MBProgressHUDMode.Text
            _ProgressHUD!.label.text = text
            _ProgressHUD!.dimBackground = true
            _ProgressHUD!.showAnimated(true, whileExecutingBlock: {
                sleep(timeOut);
            }) {
                _ProgressHUD!.removeFromSuperview()
                _ProgressHUD = nil
            }
        }
    }
    
}