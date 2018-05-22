//
//  SessionRx.swift
//  QiitaReader
//
//  Created by Takuya Matsuda on 2018/05/15.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import APIKit
import RxSwift

extension Session {
    func rx_sendRequest<T: Request>(request: T) -> Single<T.Response> {
        return Single.create { observer in
            let task = self.send(request) { result in
                switch result {
                case .success(let res):
                    observer(.success(res))
//                    observer.on(.next(res))
//                    observer.on(.completed)
                case .failure(let err):
                    observer(.error(err))
//                    observer.onError(err)
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
    
    class func rx_sendRequest<T: Request>(request: T) -> Single<T.Response> {
        return shared.rx_sendRequest(request: request)
    }
}
