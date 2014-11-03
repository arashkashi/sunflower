//
//  ParserTests.swift
//  Sunflower
//
//  Created by Arash K. on 03/11/14.
//  Copyright (c) 2014 Arash K. All rights reserved.
//

import UIKit
import XCTest

class ParserTests: XCTestCase {
    
    var inputText: String = "Die geringen Höhenunterschiede innerhalb der Stadt bewirken an sich ein eher homogenes Stadtklima, allerdings führt die dichte Bebauung in der City und den Bezirkszentren zu teilweise deutlichen Temperaturunterschieden im Vergleich zu großen innerstädtischen Freiflächen, insbesondere aber zu den ausgedehnten Landwirtschaftsflächen im Umland. Vor allem in Sommernächten werden Temperaturunterschiede von bis zu 10 °C gemessen. Insgesamt jedoch profitiert Berlin auch in diesem Zusammenhang von seinem großen Grünflächenanteil, mehr als 40 Prozent des Stadtgebietes sind Grünbestand; 2012 „säumten 439.971 Bäume die Straßen“. Die große Anzahl kleinerer Freiflächen, besonders aber auch die großen innerstädtischen Grünflächen wie der Große Tiergarten, der Grunewald und der ehemalige Flughafen Tempelhof mit der Hasenheide, die von Klimatologen auch als „Kälteinseln“ bezeichnet werden, bewirken zumindest in ihrer Umgebung ein zumeist als weitgehend angenehm empfundenes Klima."

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTokenise() {
//        var tokens = Parser.sharedInstance.tokenize(self.inputText)
//        XCTAssert(tokens.count > 0, "Pass")
    }
    
    func testDictionarySort() {
        var dict = ["a":1, "b":600, "c":2, "d": 800]
        var sortedKeys = Parser.sortedKeysByValueFor(dict)
        XCTAssert(sortedKeys == ["a", "c", "b", "d"], "pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
