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
