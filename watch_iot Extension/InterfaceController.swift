//
//  InterfaceController.swift
//  watch_iot Extension
//
//  Created by inner on 2016/01/10.
//  Copyright © 2016年 inner. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    let wcSession = WCSession.defaultSession()

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        init_send()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func init_send() {
        
        // Configure interface objects here.
        // WCSessionの開始
        if WCSession.isSupported() {
            wcSession.delegate = self
            wcSession.activateSession()
        }
        
        // reachableの確認
        if wcSession.reachable {
            print("reachable")
            // reachableであればメッセージを送る
            sendMessageToParent("init")
        }
        else{
            print("not reachable")
        }
    }

    // button click action
    @IBAction func cooling_click() {
        sendMessageToParent("cooling")
    }
    
    @IBAction func heating_click() {
        sendMessageToParent("heating")
    }
    
    @IBAction func stop_click() {
        sendMessageToParent("stop")
    }
    
    // send message
    func sendMessageToParent(msg:String){
        print("sendMessageToParent()")
        let message = [ "toParent" : msg ]
        wcSession.sendMessage(message, replyHandler: { replyDict in }, errorHandler: { error in })
        
    }

}
