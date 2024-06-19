//
//  SampleAppTests.swift
//  SampleAppTests
//
//  Created by koala panda on 2024/06/19.
//

import XCTest
@testable import SampleApp

class PasswordValidatorTests: XCTestCase {
    // 8文字以上であること
    func test数字が2文字含まれており_合計7文字入力された場合にfalseが返されること() {
        XCTAssertFalse(validate(password: "abcde12"))
    }

    func test数字が2文字含まれており_合計8文字入力された場合にtrueが返されること() { XCTAssertTrue(validate(password: "abcdef12"))
    }

    func test数字が2文字含まれており_合計9文字入力された場合にtrueが返されること() { XCTAssertTrue(validate(password: "abcdefg12"))
    }

    // 数字が2文字以上利用されていること
    func test数字以外を7文字と_数字が1文字入力された場合にfalseが返されること() {
        XCTAssertFalse(validate(password: "abcdefg1"))
    }

    func test数字以外を7文字と_数字が2文字入力された場合にtrueが返されること() { XCTAssertTrue(validate(password: "abcdefg12"))
    }

    func test数字以外を7文字と_数字が3文字入力された場合にtrueが返されること() { XCTAssertTrue(validate(password: "abcdefg123"))
    }
}


final class SampleAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
