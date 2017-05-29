//
//  ViewModel.swift
//  LeafLanguage
//
//  Created by LeafMaple on 16/6/15.
//  Copyright © 2016年 LeafMaple. All rights reserved.
//

import Foundation

class ViewModel {
    static func GetActiveController() -> UIViewController? {
        
        var activityViewController:UIViewController? = nil
        
        var window = UIApplication.shared.keyWindow!
        if (window.windowLevel != UIWindowLevelNormal) {
            let windows = UIApplication.shared.windows
            for item in windows {
                window = item 
            }
        }
        
        var viewsArray = window.subviews
        if(viewsArray.count > 0) {
            
            let frontView = viewsArray[0]
            let nextResponder = frontView.next
            
            if (nextResponder! is UIViewController) {
                activityViewController = nextResponder as? UIViewController
            }
            else {
                activityViewController = window.rootViewController
            }
        }
        
        return activityViewController;
    }
}
