//
//  SampleAppTests.swift
//  SampleAppTests
//
//  Created by koala panda on 2024/06/19.
//

import XCTest
import Quick
import Nimble
@testable import SampleApp

class PasswordValidatorSpec: QuickSpec {
    override func spec() {
        describe("パスワードバリデーションの文字数") {
            context("数字が2文字以上含まれている場合") {
                context("合計7文字が入力された場合") {
                    it("should be invalid") {
                        expect(PasswordValidator.validate(password: "abcde12")).to(beFalse())
                    }
                }

                context("合計8文字が入力された場合") {
                    it("should be valid") {
                        expect(PasswordValidator.validate(password: "abcdef12")).to(beTrue())
                    }
                }

                context("合計9文字が入力された場合") {
                    it("should be valid") {
                        expect(PasswordValidator.validate(password: "abcdefg12")).to(beTrue())
                    }
                }
            }
        }
    }
}
// Quick を利用したテストコードの基本形
class BasicSpec: QuickSpec {
    override func spec() {
        describe("String#isEmpty") {
            context("when an empty stirng is given") {
                it("returns true") {
                    XCTAssertTrue("".isEmpty)
                }
            }

            context("when string is blank") {
                it("returns false") {
                    XCTAssertFalse(" ".isEmpty)
                }
            }
        }
    }
}
// モックの例 電卓にロガーを仕込む例
protocol LoggerProtocol {
    func sendLog(message: String)
}

class MockLogger: LoggerProtocol {
    var invokedSendLog = false
    var invokedSendLogCount = 0
    var sendLogProperties: [String] = []

    func sendLog(message: String) {
        invokedSendLog = true
        invokedSendLogCount += 1
        sendLogProperties.append(message)
    }
}

class Calculator {
    private let logger: LoggerProtocol

    init(logger: LoggerProtocol) {
        self.logger = logger
    }

    // 計算の実行を最後にまとめておこなうためのenum型
    private enum CalcAction {
        case add(Int)
        // 引き算、割り算などの演算方法も追加されていくはず
    }

    private var calcActions: [CalcAction] = []

    // 電卓において計算の実行は最後に行いたいので、calcActionsとして
    // 行いたい計算方法を蓄積します
    func add(num: Int) {
        calcActions.append(.add(num))
    }

    func calc() -> Int {
        logger.sendLog(message: "Start calc.")
        var total = 0

        // 蓄積されたcalcActionsをもとに、実際に計算を行なっていく処理
        calcActions.forEach { calcAction in
            switch calcAction {
            case .add(let num):
                logger.sendLog(message: "Add \(num).")
                total += num
            }
        }
        logger.sendLog(message: "Total is \(total).")
        logger.sendLog(message: "Finish calc.")
        return total
    }
}

class CalculatorTests: XCTestCase {
    func testAdd() {
        let mockLogger = MockLogger()
        let calculator = Calculator(logger: mockLogger)
        let expectedSendMessages = [
            "Start calc.", "Add 1.", "Total is 1.", "Finish calc."
        ]

        calculator.add(num: 1)
        XCTAssertEqual(calculator.calc(), 1)

        // 2
        XCTAssertTrue(mockLogger.invokedSendLog)
        XCTAssertEqual(mockLogger.invokedSendLogCount, 4)
        XCTAssertEqual(mockLogger.sendLogProperties, expectedSendMessages)
    }
}


// スタブの例
// ログイン状態に応じてダイアログの表示・非表示を切り替える例
// 1
protocol AuthManagerProtocol {
    var isLoggedIn: Bool { get }
}

// 2
class StubAuthManager: AuthManagerProtocol {
    var isLoggedIn: Bool = false
}

class DialogManager {
    // 1, 2
    private let authManager: AuthManagerProtocol

    init(authManager: AuthManagerProtocol) {
        self.authManager = authManager
    }

    var shouldShowLoginDialog: Bool {
        return !authManager.isLoggedIn
    }
}

class DialogManagerTests: XCTestCase {
    func testShowLoginDialog_ログイン済み() {
        let stubAuthManager = StubAuthManager()
        stubAuthManager.isLoggedIn = true // 3
        let dialogManager = DialogManager(authManager: stubAuthManager)
        XCTAssertFalse(dialogManager.shouldShowLoginDialog)
    }

    func testShowLoginDialog_未ログイン() {
        let stubAuthManager = StubAuthManager()
        stubAuthManager.isLoggedIn = false // 3
        let dialogManager = DialogManager(authManager: stubAuthManager)
        XCTAssertTrue(dialogManager.shouldShowLoginDialog)
    }
}


// アサーションのクロージャでエラーを受けるサンプル
enum OperationError: Error {
    case divisionByZero
}

func divide(_ x: Int, by y: Int) throws -> Int {
    if y == 0 {
        throw OperationError.divisionByZero
    }

    return x / y
}

class ExceptionTests: XCTestCase {
    func testDivideWhenDivisionByZero() {
        XCTAssertThrowsError(try divide(3, by: 0)) { error in
            let error = error as? OperationError
            XCTAssertEqual(error, OperationError.divisionByZero)
        }
    }
}
// 非同期処理のテスト
class AsyncTests: XCTestCase {
    func testAsyncString() {
        // 非同期処理の待機と完了を表現するためのインスタンス
        // descriptionは任意のもので構いません。
        let exp = XCTestExpectation(description: "Async String")

        // 非同期処理の関数の呼び出し
        asyncString { string in
            XCTAssertEqual(string, "文字列A")
            exp.fulfill()
        }
        // 待機を行うXCTestExpectationのインスタンスを指定する。
        // timeoutで指定した5秒以内にexpのfulfillが呼び出されない場合、
        // このテストは失敗となる。
        wait(for: [exp], timeout: 5.0)
    }
}

// 独自のアサーションメソッド
extension String {
    func isOnlyNumeric() -> Bool {
        // 文字列を.decimalDigitsのみでトリミングした場合に存在する文字の数が0個以下
        return self.trimmingCharacters(in: .decimalDigits).count <= 0
    }
}

func assertOnlyNumeric(string: String,
                     file: StaticString = #file,
                     line: UInt = #line) {
    XCTAssertTrue(
        string.isOnlyNumeric(),
        "\"\(string)\" is not only numeric.",
        file: file,
        line: line)
}

class NumericStringTests: XCTestCase {
    func testIsOnlyNumericString() {
        let numericStr = "a0123456789"
        assertOnlyNumeric(string: numericStr)
    }
}

class PasswordValidatorTests: XCTestCase {
    // 8文字以上であること
    func test数字が2文字含まれており_合計7文字入力された場合にfalseが返されること() {
        XCTAssertFalse(PasswordValidator.validate(password: "abcde12"))
    }

    func test数字が2文字含まれており_合計8文字入力された場合にtrueが返されること() { XCTAssertTrue(PasswordValidator.validate(password: "abcdef12"))
    }

    func test数字が2文字含まれており_合計9文字入力された場合にtrueが返されること() { XCTAssertTrue(PasswordValidator.validate(password: "abcdefg12"))
    }

    // 数字が2文字以上利用されていること
    func test数字以外を7文字と_数字が1文字入力された場合にfalseが返されること() {
        XCTAssertFalse(PasswordValidator.validate(password: "abcdefg1"))
    }

    func test数字以外を7文字と_数字が2文字入力された場合にtrueが返されること() { XCTAssertTrue(PasswordValidator.validate(password: "abcdefg12"))
    }

    func test数字以外を7文字と_数字が3文字入力された場合にtrueが返されること() { XCTAssertTrue(PasswordValidator.validate(password: "abcdefg123"))
    }
}

// XCTContext によって構造化したコード
class PasswordValidatorTests2: XCTestCase {
    func testパスワードバリデーションの文字数() {
        XCTContext.runActivity(named: "数字が2文字以上含まれている場合") { _ in XCTContext.runActivity(named: "合計7文字が入力された場合") { _ in
            XCTAssertFalse(PasswordValidator.validate(password: "abcde12"))
            }
            XCTContext.runActivity(named: "合計8文字が入力された場合") { _ in XCTAssertTrue(PasswordValidator.validate(password: "abcdef12"))
            }
            XCTContext.runActivity(named: "合計9文字が入力された場合") { _ in XCTAssertTrue(PasswordValidator.validate(password: "abcdefg12"))
            }
        }
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
