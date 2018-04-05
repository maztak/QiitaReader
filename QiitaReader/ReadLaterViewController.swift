//
//  ReadLaterViewController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/09.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import RealmSwift
//po Realm.Configuration.defaultConfiguration.fileURL
//Users/takuya/Library/Developer/CoreSimulator/Devices/7D56EB91-5DBD-40C7-8E54-4210D2C05D0E/data/Containers/Data/Application/4760CF7F-09A8-4916-96F7-1F027E294AEA/Documents/default.realm
//FinderでShift+cmd+gで絶対パスを指定

class RealmTest3: Object {
    // dynamic修飾子を付けないといけない
    @objc dynamic var title = ""
    @objc dynamic var authorName = ""
    @objc dynamic var authorImageUrl = ""
    @objc dynamic var goodCnt = 0
    @objc dynamic var tag1 = ""
    @objc dynamic var tag2 = ""
    @objc dynamic var tag3 = ""
    @objc dynamic var url = ""
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
}


class ReadLaterViewController: UIViewController {
    
    ////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // モデル作成
        let myRealm = RealmTest3(value: [
            "title" : "はじめてのiOS開発",
            "authorName": "テスト太郎",
            "authorImageUrl": "http://sampleImage",
            "goodCnt": 3,
            "tag1": "iOS",
            "tag2": "swift",
            "tag3": "Xcode",
            "url": "http://testUrl.com"
            ])
        
        // デフォルトRealmを取得する(おまじない)
        let realm = try! Realm()
        
        // トランザクションを開始して、オブジェクトをRealmに追加する
        try! realm.write {
            realm.add(myRealm)
        }
        
        // 追記　読み取り部分//////
//        let objs = realm.objects(RealmTest2.self).filter("authorName == テスト太郎")
//        if let obj = objs.first {
//            print(obj)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ////////////////////////////////////////////////////////////
    
   

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
