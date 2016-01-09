//
//  ViewController.swift
//  WatchApp
//
//  Created by inner on 2016/01/10.
//  Copyright © 2016年 inner. All rights reserved.
//

import UIKit
import Social
import Accounts

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getTwitterAccountsFromDevice()
        selectTwitterAccount()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // button click action iphone
    @IBAction func cooling_click(sender: AnyObject) {
        // tweet cooling
        postTweet("cooling")
    }
    @IBAction func heating_click(sender: AnyObject) {
        // tweet heating
        postTweet("heating")
    }
    @IBAction func stop_click(sender: AnyObject) {
        // tweet stop
        postTweet("stop")
    }
    
    // Twitter 関連
    // ------ Twitter Account -------
    let twitter_account: String = ""  // @ 以下のアカウント名を入力
    // ------------------------------
    
    
    var accountStore = ACAccountStore() //Twitter、Facebookなどの認証を行うクラス
    var twAccount: ACAccount? //Twitterのアカウントデータを格納する
    
    /* iPhoneに設定したTwitterアカウントの情報を取得する */
    func getTwitterAccountsFromDevice(){
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (granted:Bool, aError:NSError?) -> Void in
            
            // アカウント取得に失敗したとき
            if let error = aError {
                print("Error! - \(error)")
                return;
            }
            
            // アカウント情報へのアクセス権限がない時
            if !granted {
                print("Cannot access to account data")
                return;
            }
        }
    }
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
}

