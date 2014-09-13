//
//  LMCTestCase.swift
//  Little Man Computer
//
//  Created by Dan Horwood on 9/06/2014.
//  Copyright (c) 2014 Dan Horwood. All rights reserved.
//

import XCTest

class LMCTestCase: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSplitsHaltInstruction() {
        // This is an example of a functional test case.
        let result = LMC.analyseInstructions(000)
        XCTAssertEqual(<#expression1: @auto_closure () -> T#>, <#expression2: @auto_closure () -> T#>, <#message: String#>, file: <#String#>, line: <#Int#>)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
