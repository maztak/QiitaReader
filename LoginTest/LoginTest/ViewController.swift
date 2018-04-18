//
//  ViewController.swift
//  LoginTest
//
//  Created by Takuya Matsuda on 2018/04/18.
//  Copyright © 2018年 Takuya Matsuda. All rights reserved.
//

import UIKit
import OAuthSwift

class LoginViewController: UIViewController, URLSessionDelegate, URLSessionDataDelegate {
    
    // URLの材料
    let consumerData:[String:String] =
        ["consumerKey":"aaaaaaaaaaaaaaaaaaaaaaa", // コンシューマキー
            "consumerSecret":"bbbbbbbbbbbbbbbbbbbbbbbb"] // コンシューマシークレット
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let loginAlert = UIAlertController(title: "ログイン", message: "", preferredStyle: .alert)
        loginAlert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "username"
        })
        loginAlert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "passwd"
            textField.isSecureTextEntry = true
        })
        // Loginボタン生成
        let login = UIAlertAction(title: "Login", style: .default, handler: { action -> Void in
            // 押された時の処理
            // ログイン処理
            self.tryLogin(textFeild: loginAlert.textFields!)
            // 判定
            if self.lookQuery() == false {
                // 失敗したら、もう１度Alertを表示
                self.present(loginAlert, animated: true, completion: nil)
            } else {
                // 成功したら、ArticleViewControllerに遷移
                self.tabBarController?.selectedIndex = 0
            }
        })
        // Acitonを追加
        loginAlert.addAction(login)
        // Alert表示
        present(loginAlert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ログイン判定
    func lookQuery() -> Bool {
        
        return true
    }
    
    
    // ログイン処理
    func tryLogin(textFeild: [UITextField]) {
        
        // AlertのTextFieldから値を取得
        let username = textFeild[0].text
        let passwd = textFeild[1].text
        
        print("\(username)")
        print("\(passwd)")
        
        let oauthswift = OAuth2Swift(
            consumerKey:    "<consumerKey>",
            consumerSecret: "<consumerSecret>",
            authorizeUrl:   "https://qiita.com/api/v2/oauth/authorize",
            accessTokenUrl: "https://qiita.com/api/v2/access_tokens ",
            responseType:   "code"
        )
        oauthswift.authorize(withCallbackURL: NSURL(string: "smartqiita://oauth-callback"),
                             scope: "",
                             state: "",
                             success: { credential, response, parameters in
                                print(credential.oauth_token)
                                // トークンを保存
                                let defaults = NSUserDefaults.standardUserDefaults()
                                defaults.setValue(credential.oauth_token, forKey: "oauth_token")
                                // 画面遷移
                                self.tabBarController?.selectedIndex = 0},
                             failure: { error in
                                print(error.localizedDescription)
                                
        }
        )
    }
}

