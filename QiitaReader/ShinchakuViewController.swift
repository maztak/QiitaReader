//
//  ShinchakuViewController.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/09.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit

class ShinchakuViewController: UIViewController {

    
    @IBOutlet weak var picture1: UIImageView!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var author1: UILabel!
    @IBOutlet weak var goodCnt1: UILabel!
  
    @IBOutlet weak var tag1_1: UILabel!
    @IBOutlet weak var tag1_2: UILabel!
    @IBOutlet weak var tag1_3: UILabel!
    
    @IBAction func atodeYomu1(_ sender: Any) {
    }
    
    @IBAction func yomikomi(_ sender: Any) {
        title1.text = article1.title
        author1.text = article1.authorName
        goodCnt1.text = article1.goodCnt
        tag1_1.text = article1.tag1
        tag1_2.text = article1.tag2
        tag1_3.text = article1.tag3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
