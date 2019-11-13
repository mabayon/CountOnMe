//
//  ReduceOperationTestCase.swift
//  CountOnMeTests
//
//  Created by Mahieu Bayon on 13/11/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class ReduceOperationTestCase: XCTestCase {
    
    var reduceOperation: ReduceOperation!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func setReduceOperation(elements: [String]) {
        reduceOperation = ReduceOperation(operationsToReduce: elements)
    }
    
    func testGivenElementAre3And5_WhenTheyAreAddedTogether_ThenOperationReducedShouldBe8() {
        
        // When
        let elements = ["3", "+", "5"]
        setReduceOperation(elements: elements)
        
        // Then
        if let operationReduced = reduceOperation.operationsReduced,
            let intOperationsReduced = Int(operationReduced) {
            XCTAssertEqual(intOperationsReduced, 8)
        }
    }
    
    func testGivenElementAre19And9_WhenTheyAreSubtracted_ThenOperationReducedShouldBe10() {
        
        // When
        let elements = ["19", "-", "9"]
        setReduceOperation(elements: elements)
        
        // Then
        if let operationReduced = reduceOperation.operationsReduced,
            let intOperationsReduced = Int(operationReduced) {
            XCTAssertEqual(intOperationsReduced, 10)
        }
    }
}

