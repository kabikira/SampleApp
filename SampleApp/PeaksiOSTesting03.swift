//
//  PeaksiOSTesting03.swift
//  SampleApp
//
//  Created by koala panda on 2024/06/19.
//

import Foundation

func validate(password: String) -> Bool {
    if password.count <= 7 {
        return false
    }
    let numString = password.components(
        separatedBy: CharacterSet.decimalDigits.inverted).joined()
    return numString.count >= 2
}

