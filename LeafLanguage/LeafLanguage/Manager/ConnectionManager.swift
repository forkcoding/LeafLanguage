//
//  ConnectionManager.swift
//  LeafLanguage
//
//  Created by LeafMaple on 15/6/9.
//  Copyright (c) 2015年 LeafMaple. All rights reserved.
//

import Foundation

class ConnectionManager : NSObject, NSURLConnectionDataDelegate {
    
    fileprivate var _Buffer = NSMutableData()
    fileprivate var _ProgressHUD: MBProgressHUD?
    fileprivate var _ContentLength: Int64 = 0
    fileprivate var _ReceiveLenght: Int64 = 0
    
    func GetHttpData(_ httpURL: String) -> Data? {
        
        HttpConnection(httpURL)
        CFRunLoopRun()
        
        return GetReceiveData()
    }
    
    func HttpConnection(_ httpURL: String) {
        
        let viewController = ViewModel.GetActiveController()
        _ProgressHUD = MBProgressHUD.showAdded(to: viewController!.view, animated: true)
        
        if (_ProgressHUD != nil) {
            _ProgressHUD!.mode = MBProgressHUDMode.determinateHorizontalBar
            _ProgressHUD!.label.text = "下载中..."
            _ProgressHUD!.dimBackground = true
            //_ProgressHUD!.color = UIColor.purpleColor()
        }
        
        let url = URL(string: httpURL)
        let requrst = NSMutableURLRequest(url: url!)

        requrst.setValue("", forHTTPHeaderField: "Accept-Encoding")
        
        NSURLConnection(request: requrst as URLRequest, delegate: self, startImmediately: true)
        
    }
    
    func GetDownLoadString() -> String {
        return "\(_ReceiveLenght / 1024)KB / \(_ContentLength / 1024)KB"
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        
        _ContentLength = response.expectedContentLength
        
        NSLog("Content length is %lli.", _ContentLength)
        
    }
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        
        NSLog(error.localizedDescription)
        
    }
    
    func connection(_ connection: NSURLConnection, didReceive data: Data){
        
        let fPercent = Float(_ReceiveLenght) / Float(_ContentLength)
        
        if (_ProgressHUD != nil) {
            _ProgressHUD?.detailsLabel.text = GetDownLoadString()
            _ProgressHUD?.progress = fPercent
        }
        
        _Buffer.append(data)
        _ReceiveLenght += data.count
        
        NSLog("Data recvive is %lli.", _ReceiveLenght)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection)
    {
        NSLog("connectionDidFinishLoading")
        
        _ProgressHUD?.hide(true)
        
        CFRunLoopStop(CFRunLoopGetCurrent())
    }
    
    func GetReceiveData() -> Data?{
        return _Buffer as Data
    }
}
