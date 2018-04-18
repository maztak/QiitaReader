//
//  ArticleCell.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/03/26.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var goodCnt: UILabel!
    @IBOutlet weak var tag1: UILabel!
    @IBOutlet weak var tag2: UILabel!
    @IBOutlet weak var tag3: UILabel!
    @IBOutlet weak var authorIcon: UIImageView!
    var delegate: ArticleCellDelegate? = nil //代理人（処理の委譲先）関数をもつプロパティ
    
    @IBAction func readLaterButtonTapped(_ sender: Any) {
        delegate?.addReadLater(cell: self)
    }
}





