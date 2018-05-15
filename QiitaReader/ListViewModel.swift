//
//  ListViewModel.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/05/15.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import RxSwift
import APIKit
//
//class ArticleViewModel: NSObject, UITableViewDataSource {
//
//    private var cellIdentifier = "ArticleCell"
//    private(set) var article = Variable<[NewArticle]>([])
//    private(set) var error = Variable<Error?>(nil)
//    let disposeBag = DisposeBag()
//
//    override init() {
//        super.init()
//    }
//
//    func reloadData() {
//        let request = GetNewRequest()
//        Session.rx_sendRequest(request: request)
//            .subscribe {
//                [weak self] event in
//                switch event {
//                case .next(let article):
//                    self?.article.value = article
//                case .error(let error): break
//                self?.error.value = error
//                default: break
//                }
//            }
//            .disposed(by: disposeBag)
//    }
//
//    // MARK: - TableView
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return article.value.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! ArticleCell
//        cell.configureCell(repo: article.value[indexPath.row])
//        return cell
//    }
//}
