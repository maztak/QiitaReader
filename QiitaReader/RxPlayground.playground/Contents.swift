//: Playground - noun: a place where people can play

import UIKit
import RxSwift
import RxCocoa

struct Student {
    
    var score: Variable<Int>
}

do {
    
    let disposeBag = DisposeBag()
    
    // 1
    let ryan = Student(score: Variable(80))
    let charlotte = Student(score: Variable(90))
    
    // 2
    let student = PublishSubject<Student>()
    
    // 3
    student.asObservable()
        .flatMap {
            $0.score.asObservable()
        }
        // 4
        .subscribe(onNext: {
            print($0)
        })
        .disposed(by: disposeBag)
}
