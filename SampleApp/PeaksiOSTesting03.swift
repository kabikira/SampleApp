//
//  PeaksiOSTesting03.swift
//  SampleApp
//
//  Created by koala panda on 2024/06/19.
//

import Foundation

class PasswordValidator {
   static func validate(password: String) -> Bool {
        if password.count <= 7 {
            return false
        }
        let numString = password.components(
            separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return numString.count >= 2
    }
}

// 非同期のテスト
func asyncString(completion: ((String) -> ())?) {
    DispatchQueue.global().async {
        sleep(3)

        completion?("文字列A")
    }
}

// Nimbleを使用するモチベーション
struct Person: Equatable {
    var name: String
    var age: Int
}

extension Sequence where Element == Person {
    func teens() -> [Person] {
        return self.filter { (13..<19).contains($0.age) }
    }
}

let members = [
    Person(name: "山田", age: 12),
    Person(name: "高橋", age: 13),
    Person(name: "細沼", age: 19),
    Person(name: "佐藤", age: 20),
]
