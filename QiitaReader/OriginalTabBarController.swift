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
        // NavBarのtitleLabelをセット
        let title = UILabel()
        title.text = "QiitaReader"
        title.font = UIFont(name: "Heiti TC", size: 23)
        title.textColor = UIColor.white
        self.navigationItem.titleView = title
        // fontの設定
        let fontFamily: UIFont! = UIFont.systemFont(ofSize: 10)
        // 選択時の設定
        let selectedColor:UIColor = UIColor.blue
        let selectedAttributes = [NSAttributedStringKey.font: fontFamily, NSAttributedStringKey.foregroundColor: selectedColor] as [NSAttributedStringKey : Any]
        /// タイトルテキストカラーの設定
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: UIControlState.selected)
        /// アイコンカラーの設定
        UITabBar.appearance().tintColor = selectedColor

        
        // 非選択時の設定
        let nomalAttributes = [NSAttributedStringKey.font: fontFamily, NSAttributedStringKey.foregroundColor: UIColor.white] as [NSAttributedStringKey : Any]
        // タイトルテキストカラーの設定
        UITabBarItem.appearance().setTitleTextAttributes(nomalAttributes, for: UIControlState.normal)
        // アイコンカラー（画像）の設定
        var assets :Array<String> = ["ic_new_releases_white.png", "ic_trending_up_white.png", "ic_access_time_white.png"]
        for (idx, item) in self.tabBar.items!.enumerated() {
            item.image = UIImage(named: assets[idx])?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        }
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
