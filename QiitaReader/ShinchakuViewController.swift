//
//  ShinchakuViewController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/09.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit

class ShinchakuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var picture1: UIImageView!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var goodCnt1: UILabel!
    @IBOutlet weak var author1: UILabel!
    @IBOutlet weak var tag1_1: UILabel!
    @IBOutlet weak var tag1_2: UILabel!
    @IBOutlet weak var tag1_3: UILabel!
    
    @IBAction func atodeYomu1(_ sender: Any) {
    }
    @IBAction func yomikomi(_ sender: Any) {
        title1.text = article1.title
        print(title1.text ?? "title")
        author1.text = article1.authorName
        goodCnt1.text = article1.goodCnt
        tag1_1.text = article1.tag1
        tag1_2.text = article1.tag2
        tag1_3.text = article1.tag3
    }
    
    //配列fruitsを設定
    let fruits = ["apple", "orange", "melon", "banana", "pineapple"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: "ArticleCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: ArticleCell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        
        // セルに表示する値を設定する
        cell.textLabel!.text = fruits[indexPath.row]
        
        return cell
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
