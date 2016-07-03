//
//  ConnectionManager.swift
//  LeafLanguage
//
//  Created by LeafMaple on 15/6/9.
//  Copyright (c) 2015年 LeafMaple. All rights reserved.
//

import Foundation

class ConnectionManager : NSObject, NSURLConnectionDataDelegate {
    
    private var _Buffer = NSMutableData()
    private var _ProgressHUD: MBProgressHUD?
    private var _ContentLength: Int64 = 0
    private var _ReceiveLenght: Int64 = 0
    
    func GetHttpData(httpURL: String) -> NSData? {
        
        HttpConnection(httpURL)
        CFRunLoopRun()
        
        return GetReceiveData()
    }
    
    func HttpConnection(httpURL: String) {
        
        let viewController = ViewModel.GetActiveController()
        _ProgressHUD = MBProgressHUD.showHUDAddedTo(viewController!.view, animated: true)
        
        if (_ProgressHUD != nil) {
            _ProgressHUD!.mode = MBProgressHUDMode.DeterminateHorizontalBar
            _ProgressHUD!.label.text = "下载中..."
            _ProgressHUD!.dimBackground = true
            //_ProgressHUD!.color = UIColor.purpleColor()
        }
        
        let url = NSURL(string: httpURL)
        let requrst = NSMutableURLRequest(URL: url!)

        requrst.setValue("", forHTTPHeaderField: "Accept-Encoding")
        
        NSURLConnection(request: requrst, delegate: self, startImmediately: true)
        
    }
    
    func GetDownLoadString() -> String {
        return "\(_ReceiveLenght / 1024)KB / \(_ContentLength / 1024)KB"
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
        _ContentLength = response.expectedContentLength
        
        NSLog("Content length is %lli.", _ContentLength)
        
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        
        NSLog(error.localizedDescription)
        
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData){
        
        let fPercent = Float(_ReceiveLenght) / Float(_ContentLength)
        
        if (_ProgressHUD != nil) {
            _ProgressHUD?.detailsLabel.text = GetDownLoadString()
            _ProgressHUD?.progress = fPercent
        }
        
        _Buffer.appendData(data)
        _ReceiveLenght += data.length
        
        NSLog("Data recvive is %lli.", _ReceiveLenght)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection)
    {
        NSLog("connectionDidFinishLoading")
        
        _ProgressHUD?.hide(true)
        
        CFRunLoopStop(CFRunLoopGetCurrent())
    }
    
    func GetReceiveData() -> NSData?{
        return _Buffer
    }
}