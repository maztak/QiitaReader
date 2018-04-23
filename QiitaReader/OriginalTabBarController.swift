//
//  OriginalTabBarController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/04/23.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit

class OriginalTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        // fontの設定
//        let fontFamily: UIFont! = UIFont.systemFontOfSize(10)
//
//        // 選択時の設定
//        let selectedColor:UIColor = UIColor(red: 65.0/255.0, green: 168.0/255.0, blue: 186.0/255.0, alpha: 1)
//        let selectedAttributes = [NSFontAttributeName: fontFamily, NSForegroundColorAttributeName: selectedColor]
//        /// タイトルテキストカラーの設定
//        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, forState: UIControlState.Selected)
//        /// アイコンカラーの設定
//        UITabBar.appearance().tintColor = selectedColor
//
        
        // 非選択時の設定
//        let nomalAttributes = [NSFontAttributeName: fontFamily, NSForegroundColorAttributeName: UIColor.whiteColor()]
        /// タイトルテキストカラーの設定
//        UITabBarItem.appearance().setTitleTextAttributes(nomalAttributes, forState: UIControlState.Normal)
        /// アイコンカラー（画像）の設定
//        var assets :Array<String> = ["ic_new_releases_white.png", "ic_trending_up_white.png", "ic_trending_up_white.png"]
//        for (idx, item) in self.tabBar.items!.enumerate() {
//            item.image = UIImage(named: assets[idx])?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
