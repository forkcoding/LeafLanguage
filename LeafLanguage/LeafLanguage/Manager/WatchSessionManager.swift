//
//  Session.swift
//  LeafLanguage
//
//  Created by LeafMaple on 2018/10/28.
//  Copyright © 2018 LeafMaple. All rights reserved.
//

//
//  WatchSessionManager.swift

import WatchKit
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {

    var _GlosList = [Any]()
    static let sharedManager = WatchSessionManager()
#if os(watchOS)
    fileprivate let session: WCSession? = WCSession.isSupported() ?  WCSession.default : nil
#else
    fileprivate let session: WCSession? = WCSession.isSupported() ?  WCSession.default() : nil
#endif
    fileprivate var validSession: WCSession? {
#if os(iOS)
        if let session = session, session.isPaired && session.isWatchAppInstalled {
            return session
        }
        return nil
#else
        return session
#endif
    }
    
    private override init() {
        super.init()
    }
    
    func startSession(_ sessionDelegate: WCSessionDelegate?) {
        session?.delegate = (sessionDelegate != nil) ? sessionDelegate : self
        session?.activate()
    }
    
    /**
     * Called when the session has completed activation.
     * If session state is WCSessionActivationStateNotActivated there will be an error with more details.
     */
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
}

// MARK: Application Context
// use when your app needs only the latest information
// if the data was not sent, it will be replaced
extension WatchSessionManager {
    
    // Sender
    func updateApplicationContext(_ applicationContext: [String : Any]) throws {
        if let session = validSession {
            do {
                try session.updateApplicationContext(applicationContext)
            } catch let error {
                throw error
            }
        }
    }
    
    // Receiver
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.async() {
#if os(watchOS)
            WatchSessionManager.sharedManager._GlosList = applicationContext["Glos"] as! [Any]
            for list in WatchSessionManager.sharedManager._GlosList {
                var dictVoc = list as! [String : String]
                for (key, value) in dictVoc {
                    print(key, value)
                }
            }
#endif
        }
    }
    
    /**
     * Called when the session can no longer be used to modify or add any new transfers and,
     * all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur.
     * This will happen when the selected watch is being changed.
     */
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    /**
     * Called when all delegate callbacks for the previously selected watch has occurred.
     * The session can be re-activated for the now selected watch using activateSession.
     */
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
}

// MARK: User Info
// use when your app needs all the data
// FIFO queue
extension WatchSessionManager {
    
    // Sender
    func transferUserInfo(userInfo: [String : AnyObject]) -> WCSessionUserInfoTransfer? {
        return validSession?.transferUserInfo(userInfo)
    }
    
    func session(session: WCSession, didFinishUserInfoTransfer userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        // implement this on the sender if you need to confirm that
        // the user info did in fact transfer
    }
    
    // Receiver
    func session(session: WCSession, didReceiveUserInfo userInfo: [String : AnyObject]) {
        // handle receiving user info
        DispatchQueue.main.async() {
            // make sure to put on the main queue to update UI!
        }
    }
    
}

// MARK: Transfer File
extension WatchSessionManager {
    
    // Sender
    func transferFile(file: NSURL, metadata: [String : AnyObject]) -> WCSessionFileTransfer? {
        return validSession?.transferFile(file as URL, metadata: metadata)
    }
    
    func session(session: WCSession, didFinishFileTransfer fileTransfer: WCSessionFileTransfer, error: Error?) {
        // handle filed transfer completion
    }
    
    // Receiver
    func session(session: WCSession, didReceiveFile file: WCSessionFile) {
        // handle receiving file
        DispatchQueue.main.async() {
            // make sure to put on the main queue to update UI!
        }
    }
}

// MARK: Interactive Messaging
extension WatchSessionManager {
    
    // Live messaging! App has to be reachable
    private var validReachableSession: WCSession? {
        if let session = validSession, session.isReachable {
            return session
        }
        return nil
    }
    
    // Sender
    func sendMessage(message: [String : Any], replyHandler: (([String : Any]) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
        validReachableSession?.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
    }
    
    func sendMessageData(data: Data, replyHandler: ((Data) -> Void)? = nil, errorHandler: ((Error) -> Void)? = nil) {
        validReachableSession?.sendMessageData(data, replyHandler: replyHandler, errorHandler: errorHandler)
    }
    
    // Receiver
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async() {
#if os(iOS)
            WatchSessionManager.sharedManager._GlosList = [Any]()
            for key in GlossaryModel.Enumerator() {
                var modelVoc = VocabularyModel.GetVocabulary(
                    LANGUAGE.japanese,
                    uniqueID: Int(key as! String)!
                    )!
                let hMirror = Mirror(reflecting: modelVoc)
                var dictVoc = [String:String]()
                for case let (label?, value) in hMirror.children {
                    dictVoc[label] = value as? String
                }
                WatchSessionManager.sharedManager._GlosList.append(dictVoc)
            }
            try? WatchSessionManager.sharedManager.sendMessage(
                message: ["Glos" : WatchSessionManager.sharedManager._GlosList]
            )
#else
            WatchSessionManager.sharedManager._GlosList = message["Glos"] as! [Any]
            for list in WatchSessionManager.sharedManager._GlosList {
                var dictVoc = list as! [String : String]
                for (key, value) in dictVoc {
                    print(key, value)
                }
            }
#endif
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async() {
        }
    }
    
    func session(session: WCSession, didReceiveMessageData messageData: NSData, replyHandler: (NSData) -> Void) {
        // handle receiving message data
        DispatchQueue.main.async() {
            // make sure to put on the main queue to update UI!
        }
    }
}
