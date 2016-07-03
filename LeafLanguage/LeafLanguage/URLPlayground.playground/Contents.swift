//: Playground - noun: a place where people can play

import Cocoa

class ConnectionManager : NSObject, NSURLConnectionDataDelegate {
    
    var m_buffer = NSMutableData()
    var responseStr: NSString?
    
    func HttpConnection(httpURL: String) {
        
        var url: NSURL?
        var requrst: NSURLRequest?
        var conn: NSURLConnection?
        
        
        url = NSURL(fileURLWithPath: httpURL)
        requrst = NSMutableURLRequest(URL: url!)
        //requrst?.timeoutInterval = 5.0

        conn = NSURLConnection(request: requrst!, delegate: self)
        
        if((conn) != nil) {
            
            print("http连接成功!")
            conn!.start()
        }
        else {
            
            print("http连接失败!")
            
        }
        
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
        print("收到服务器响应")
        
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        
        print(error.localizedDescription)
        
    }
    
    func connection(cconnection: NSURLConnection, didReceiveData data: NSData){
        
        m_buffer.appendData(data)
        
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection)
    {
        // This will be called when the data loading is finished i.e. there is no data left to be received and now you can process the data.
        NSLog("connectionDidFinishLoading")
        responseStr = NSString(data: m_buffer, encoding:NSUTF8StringEncoding)
        print(responseStr)
    }
    
    func GetData() -> NSString?
    {
        return responseStr
    }
}

var conMgr = ConnectionManager()

conMgr.HttpConnection("http://www.baidu.com")
