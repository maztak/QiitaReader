//
//  ArticleCellDelegate.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/04/18.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit

protocol ArticleCellDelegate {
    func addReadLater(cell: UITableViewCell)
    //本来はfunc articleCell(_ cell: UITableViewCell, didTapReadLaterButton: UIButton)こんな感じの名前になるのか？
    //①メソッド名ははデリゲート元のオブジェクト名から始め、続いてイベント名を説明する
    //②didやwillなどの助動詞を用いてイベントのタイミングを表す
    //③第1引数にはデリゲート元のオブジェクトを渡す
}
