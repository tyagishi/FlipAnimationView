//
//  Int+ExtensionTests.swift
//  FlipAnimationView
//
//  Created by Tomoaki Yagishita on 2025/06/05.
//

import XCTest
@testable import FlipAnimationView

final class Int_ExtensionTests: XCTestCase {

    func testDigitAt() async throws {
        XCTAssertEqual(1234.digit(at: 0), 4)
        XCTAssertEqual(1234.digit(at: 1), 3)
        XCTAssertEqual(1234.digit(at: 2), 2)
        XCTAssertEqual(1234.digit(at: 3), 1)
    }
}
