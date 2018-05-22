//: Playground - noun: a place where people can play

import UIKit
import RxSwift



//let a = Observable.just(1)
//
//a.subscribe(onNext: { (event) in
//    print("流れたで:\(event)")
//}, onError: { (error) in
//    print("エラーやで:\(error)")
//})

Observable.zip(
    Observable.from([1,2]),
    Observable.from([3,4]),
    Observable.from([5,6])
) { $0 + $1 + $2 }
    .subscribe(onNext: {
        print($0) // 9 -> 12
    })
