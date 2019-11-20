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
    
    func testGivenElementAre3And5_WhenTheyAreAddedTogether_ThenOperationReducedShouldBeEqualTo3Plus5() {
        
        // When
        let elements = ["3", "+", "5"]
        setReduceOperation(elements: elements)
        
        // Then
        if let operationReduced = reduceOperation.operationsReduced,
            let intOperationsReduced = Int(operationReduced) {
            XCTAssertEqual(intOperationsReduced, 3 + 5)
        }
    }
    
    func testGivenElementAre19And9_WhenTheyAreSubtracted_ThenOperationReducedShouldBeEqualTo19Minus9() {
        
        // When
        let elements = ["19", "-", "9"]
        setReduceOperation(elements: elements)
        
        // Then
        if let operationReduced = reduceOperation.operationsReduced,
            let intOperationsReduced = Int(operationReduced) {
            XCTAssertEqual(intOperationsReduced, 19 - 9)
        }
    }
    
    func testGivenElementAre30And29_WhenTheyAreMultiplied_ThenOperationReducedShouldBeEqualTo30X29() {
        
        // When
        let elements = ["30", "x", "29"]
        setReduceOperation(elements: elements)
        
        // Then
        if let operationReduced = reduceOperation.operationsReduced,
            let intOperationReduced = Int(operationReduced) {
            XCTAssertEqual(intOperationReduced, 30 * 29)
        }
    }
    
    func testGivenElementAre45And5_WhenTheyAreDivided_ThenOperationReducedShouldBeEqualTo45Divided5() {
        
        // When
        let elements = ["45", "/", "5"]
        setReduceOperation(elements: elements)
        
        // Then
        if let operationReduced = reduceOperation.operationsReduced,
            let intOperationReduced = Int(operationReduced) {
            XCTAssertEqual(intOperationReduced, 45 / 5)
        }
    }
    
    func testGivenElementAre32And0_WhenTheyAreDivided_ThenOperationReducedShouldBeNil() {
        // When
        let elements = ["32", "/", "0"]
        setReduceOperation(elements: elements)
        
        // Then
        if let operationReduced = reduceOperation.operationsReduced {
            XCTAssertEqual(operationReduced, "Erreur")
        }
    }
    
    func testGivenThereAreAdditionThenMultiplication_WhenOperationIsReduced_ThenCalculShouldBeginByTheMultiplication() {
        // Given
        let elements = ["34", "+", "32", "x", "13"]
        
        // When
        setReduceOperation(elements: elements)
        
        // Then
        if let operationReduced = reduceOperation.operationsReduced,
            let intOperationReduced = Int(operationReduced) {
            XCTAssertEqual(intOperationReduced, 34 + 32 * 13)
        }
    }
    
    func testGivenThereAreAdditionThenDivision_WhenOperationIsReduced_ThenCalculShouldBeginByTheDivision() {
        // Given
        let elements = ["25", "-", "12", "/", "55"]
        
        // When
        setReduceOperation(elements: elements)
        
        // Then
        if let operationReduced = reduceOperation.operationsReduced,
            let intOperationReduced = Int(operationReduced) {
            XCTAssertEqual(intOperationReduced, 25 - 12 / 55)
        }
    }
    
    func testGivenThereAreDividedThenMultiply_WhenOperationIsReduced_ThenCalculShouldBeginByTheDivisionThenTheMultiplication() {
       
        // Given
        let elements = ["23", "-", "64", "/", "12", "+", "43", "x", "14"]
        
        // When
        setReduceOperation(elements: elements)
        
        // Then
        if let operationReduced = reduceOperation.operationsReduced,
            let intOperationReduced = Int(operationReduced) {
            XCTAssertEqual(intOperationReduced, 23 - 64 / 12 + 43 * 14)
        }
    }
    
    func testGivenThereAreMultiplyThenDivided_WhenOperationIsReduced_ThenCalculShouldBeginByTheMultiplicationThenTheDivision() {
        // Given
        let elements = ["2", "+", "2", "x", "2", "/", "2"]
        
        // When
        setReduceOperation(elements: elements)
        
        // Then
        if let operationReduced = reduceOperation.operationsReduced,
            let intOperationReduced = Int(operationReduced) {
            XCTAssertEqual(intOperationReduced, 2 + 2 * 2 / 2)
        }
    }
}

