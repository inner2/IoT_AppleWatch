//
//  AppDelegate.swift
//  WatchApp
//
//  Created by inner on 2016/01/10.
//  Copyright © 2016年 inner. All rights reserved.
//

import UIKit
import WatchConnectivity

import Social
import Accounts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {

    var window: UIWindow?
    let wcSession = WCSession.defaultSession()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        if WCSession.isSupported() {
            wcSession.delegate = self
            wcSession.activateSession()
        }
        return true
    }
    
    // get message from watch
    func session(session: WCSession, didReceiveMessage message: [String: AnyObject], replyHandler: [String: AnyObject] -> Void) {
        
        // watchからのメッセージを受け取り
        if let watchMessage = message["toParent"] as? String {
            // twitter account の選択
            selectTwitterAccount()
            postTweet(watchMessage)
        }
        else{
            print("error: session receive")
        }
    }

    // Twitter関連
    // ------ Twitter Account -------
    let twitter_account: String = ""  // @ 以下のアカウント名を入力
    // ------------------------------
    var accountStore = ACAccountStore() //Twitter、Facebookなどの認証を行うクラス
    var twAccount: ACAccount? //Twitterのアカウントデータを格納する
    
    // setting twitter account
    func selectTwitterAccount(){
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        let accounts = self.accountStore.accountsWithAccountType(accountType) as! [ACAccount]
        for account in accounts {
            if account.username == twitter_account{
                twAccount = account
            }
        }
    }
    
    // ツイートを投稿
    private func postTweet(cmd: String) {
        let URL = NSURL(string: "https://api.twitter.com/1.1/statuses/update.json")
        
        let now = NSDate()
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        let date = formatter.stringFromDate(now)
        
        // ツイートしたい文章をセット
        let params = ["status" : cmd + "-" + date]
        
        // リクエストを生成
        let request = SLRequest(forServiceType: SLServiceTypeTwitter,
            requestMethod: .POST,
            URL: URL,
            parameters: params)
        
        // 取得したアカウントをセット
        request.account = twAccount
        
        // APIコールを実行
        request.performRequestWithHandler { (responseData, urlResponse, error) -> Void in
            
            if error != nil {
                print("error is \(error)")
            }
            else {
                // 結果の表示
                do {
                    let result = try NSJSONSerialization.JSONObjectWithData(responseData,
                        options: .AllowFragments) as! NSDictionary
                    
                    print("result is \(result)")
                }
                catch {
                    return
                }
            }
        }
    }

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

