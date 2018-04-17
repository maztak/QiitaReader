//
//  CustomTabBarController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/04/04.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Nuke

class CustomTabBarController: UITabBarController, UISearchBarDelegate {
    var testSearchBar: UISearchBar!
    var searchResult = [Article]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSearchBar()

        //何も入力されていなくてもReturnキーを押せるようにする。
        testSearchBar.enablesReturnKeyAutomatically = false
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ////////////////////////////////////////////////////////////////
    
    
    
    // MARK: - private methods
    private func setupSearchBar() {
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
            let searchBar: UISearchBar = UISearchBar(frame: navigationBarFrame)
            searchBar.delegate = self
            searchBar.placeholder = "検索"
            searchBar.showsCancelButton = true
            searchBar.autocapitalizationType = UITextAutocapitalizationType.none
            searchBar.keyboardType = UIKeyboardType.default
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.testSearchBar = searchBar
            searchBar.becomeFirstResponder()
        }
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
