//
//  creditManagerTests.swift
//  Sunflower
//
//  Created by Arash K. on 09/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit
import XCTest

class creditManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testConversaionRate() {
        // This is an example of a functional test case.
        var test1 = Double(CreditManager.sharedInstance.dollarToLafru(1)) == 1 / CreditManager.sharedInstance.costPerCharacter
        var test2 = CreditManager.sharedInstance.lafruToDollar(1) == CreditManager.sharedInstance.costPerCharacter
        XCTAssert(test1, "1 dollar euqal to 5000 lafru")
        XCTAssert(test2, "1 lafru euqal to 0.00002 dollar")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
