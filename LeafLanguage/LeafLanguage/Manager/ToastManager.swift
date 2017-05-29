//
//  ToastManager.swift
//  LeafLanguage
//
//  Created by LeafMaple on 16/6/27.
//  Copyright © 2016年 LeafMaple. All rights reserved.
//

import Foundation

class ToastManager {
    
    fileprivate static var _ProgressHUD: MBProgressHUD?
    
    static func Show(_ text: String?, timeOut: UInt32) {
        
        let viewController = ViewModel.GetActiveController()
        
        _ProgressHUD = MBProgressHUD.showAdded(to: viewController!.view, animated: true)
        
        if (_ProgressHUD != nil) {
            _ProgressHUD!.mode = MBProgressHUDMode.text
            _ProgressHUD!.label.text = text
            _ProgressHUD!.dimBackground = true
            _ProgressHUD!.show(animated: true, whileExecuting: {
                sleep(timeOut);
            }) {
                _ProgressHUD!.removeFromSuperview()
                _ProgressHUD = nil
            }
        }
    }
    
}
