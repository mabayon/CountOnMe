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
    
    var reduceOperation = ReduceOperation()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func reduce(operation: String) {
        reduceOperation.operationToReduce = operation
        reduceOperation.calculResult()
    }
    
    // MARK: Test addNumber()
        
    func testGivenUserAddNumber0_WhenThereIsAlreadyOneAtFirst_ThenDontAddAnOther0() {
        
        // Given
        let element = "0"
        
        // When
        reduceOperation.operationToReduce = "0"
        reduceOperation.addNumber(newElement: element)
        
        // Then
        XCTAssertEqual(reduceOperation.elements.count, 1)
    }
    
    func testGivenUserAddNumber4_WhenTheFirstNumIs0_Then4ShouldReplace0() {

        // Given
        let element = "4"
        
        // When
        reduceOperation.operationToReduce = "0"
        reduceOperation.addNumber(newElement: element)

        // Then
        XCTAssertEqual(reduceOperation.operationToReduce, "4")
    }

    func testGivenUserAddNumber6_WhenThereIsAResult_Then6ShouldReplaceTheResult() {
        // Given
        let element = "6"
        
        // When
        reduceOperation.operationToReduce = "2 + 2 = 4"
        reduceOperation.addNumber(newElement: element)

        // Then
        XCTAssertEqual(reduceOperation.operationToReduce, "6")
    }
    
    func testGivenUserAddNumber4_WhenThereIsAnError_Then4ShouldReplaceError() {
        // Given
        let element = "4"
        
        // When
        reduceOperation.operationToReduce = ""
        reduceOperation.operationReduced = "Erreur"
        reduceOperation.addNumber(newElement: element)

        // Then
        XCTAssertEqual(reduceOperation.operationToReduce, "4")
    }
    
    // MARK: Test addOperator()
    
    func testGivenUserAddPlusOperator_WhenThereIsNo_ThenShouldAddPlusToOperation() {
        // Given
        let element = "+"
        
        // When
        reduceOperation.operationToReduce = "22"
        reduceOperation.addOperator(newElement: element)

        // Then
        XCTAssertEqual(reduceOperation.operationToReduce, "22 + ")
    }
    
    func testGivenUserAddMinusOperator_WhenThereIsAlreadyOne_ThenNothingShouldHappened() {
        // Given
        let element = "-"
        
        // When
        reduceOperation.operationToReduce = "45 - "
        reduceOperation.addOperator(newElement: element)

        // Then
        XCTAssertEqual(reduceOperation.operationToReduce, "45 - ")
    }
    
    func testGivenUserAddMultiply_WhenThereIsAResult_ThenShouldSendANotification() {
        // Given
        let element = "x"
        
        // When
        reduceOperation.operationToReduce = "33 - 9 ="

        // Then
        let expect = XCTNSNotificationExpectation(name: .ErrorResult)
        reduceOperation.addOperator(newElement: element)
        wait(for: [expect], timeout: 0.1)
    }
        
    // MARK: Test addDecimal()
    
    func testGivenUserAddDecimal_WhenThereIsAResult_ThenShouldAdd0Point() {
        
        // When
        reduceOperation.operationToReduce = "45 - 5 = 40"
        reduceOperation.addDecimal()

        // Then
        XCTAssertEqual(reduceOperation.operationToReduce, "0.")
    }
    
    func testGivenUserAddDecimal_WhenThereIsAnOperator_ThenShouldAdd0Point() {
        // When
        reduceOperation.operationToReduce = "43 - "
        reduceOperation.addDecimal()
        
        // Then
        XCTAssertEqual(reduceOperation.operationToReduce, "43 - 0.")
    }
    
    func testGivenUserAddDecimal_WhenThereIsANumber_ThenShouldAddPoint() {
        // When
        reduceOperation.operationToReduce = "43 + 5"
        reduceOperation.addDecimal()
        
        // Then
        XCTAssertEqual(reduceOperation.operationToReduce, "43 + 5.")
    }
    
    func testGivenUserAddDecimal_WhenNumberIsAlreadyADecimal_ThenNothingShouldHappened() {
        // When
        reduceOperation.operationToReduce = "43 + 5."
        reduceOperation.addDecimal()
        
        // Then
        XCTAssertEqual(reduceOperation.operationToReduce, "43 + 5.")
    }
    
    // MARK: Test delete()
    
    func testGivenUserDelete_WhenItIsANumber_ThenShouldDeleteTheLastOccurence() {
        // When
        reduceOperation.operationToReduce = "123 + 5"
        reduceOperation.delete()
        
        // Then
        XCTAssertEqual(reduceOperation.operationToReduce, "123 + ")
    }
    
    func testGivenUserDelete_WhenItIsAnOperator_ThenShouldDeleteTheOperatorAndSpaceBetween() {
        // When
        reduceOperation.operationToReduce = "123 + "
        reduceOperation.delete()
        
        // Then
        XCTAssertEqual(reduceOperation.operationToReduce, "123")
    }
    
    func testGivenUserDelete_WhenThereIsOnlyOneOccurence_ThenShouldDeleteAndReplaceBy0() {
        // When
        reduceOperation.operationToReduce = "5"
        reduceOperation.delete()
        
        // Then
        XCTAssertEqual(reduceOperation.operationToReduce, "0")
    }
    
    // MARK: Test result()
        
    func testGivenUserTapEqual_WhenThereIsAResult_ThenShouldSendNotification() {
        
        // When
        reduceOperation.operationToReduce = "33 - 9 ="

        // Then
        let expect = XCTNSNotificationExpectation(name: .ErrorResult)
        reduceOperation.calculResult()
        wait(for: [expect], timeout: 0.1)
    }
    
    func testGivenUserTapEqual_WhenThereIsErrorPrint_ThenShouldSendNotification() {
        // When
        reduceOperation.operationReduced = "Erreur"

        // Then
        let expect = XCTNSNotificationExpectation(name: .ErrorResult)
        reduceOperation.calculResult()
        wait(for: [expect], timeout: 0.1)
    }

    func testGivenUserTapEqual_WhenThereIsNotEnoughElements_ThenShouldSendNotification() {
        // When
        reduceOperation.operationReduced = "1 +"

        // Then
        let expect = XCTNSNotificationExpectation(name: .ErrorExpression)
        reduceOperation.calculResult()
        wait(for: [expect], timeout: 0.1)
    }
    
    func testGivenUserTapEqual_WhenExpressionIsIncorrect_ThenShouldSendNotification() {
        // When
        reduceOperation.operationReduced = "1 + 2 +"

        // Then
        let expect = XCTNSNotificationExpectation(name: .ErrorExpression)
        reduceOperation.calculResult()
        wait(for: [expect], timeout: 0.1)
    }
    
    // MARK: Test operations
    
    func testGivenElementAre3And5_WhenTheyAreAddedTogether_ThenOperationReducedShouldBeEqualTo3Plus5() {
        
        // Given
        let operation = "3 + 5"
        
        // When
        reduce(operation: operation)
        
        // Then
        if let intOperationsReduced = Double(reduceOperation.operationReduced) {
            XCTAssertEqual(intOperationsReduced, 3 + 5)
        }
    }
        
    func testGivenElementAre19And9_WhenTheyAreSubtracted_ThenOperationReducedShouldBeEqualTo19Minus9() {

        // Given
        let operation = "19 - 9"
        
        // When
        reduce(operation: operation)

        // Then
        if let intOperationsReduced = Double(reduceOperation.operationReduced) {
            XCTAssertEqual(intOperationsReduced, 19 - 9)
        }
    }

    func testGivenElementAre30And29_WhenTheyAreMultiplied_ThenOperationReducedShouldBeEqualTo30X29() {

        // Given
        let operation = "30 x 29"
        
        // When
        reduce(operation: operation)

        // Then
        if let intOperationReduced = Double(reduceOperation.operationReduced) {
            XCTAssertEqual(intOperationReduced, 30 * 29)
        }
    }

    func testGivenElementAre45And5_WhenTheyAreDivided_ThenOperationReducedShouldBeEqualTo45Divided5() {

        // Given
        let operation = "45 / 5"
        
        // When
        reduce(operation: operation)

        // Then
        if let intOperationReduced = Double(reduceOperation.operationReduced) {
            XCTAssertEqual(intOperationReduced, 45 / 5)
        }
    }

    func testGivenElementAre32And0_WhenTheyAreDivided_ThenOperationReducedShouldBeError() {
        // Given
        reduceOperation.operationToReduce = "32 / 0"
      
        // When
        reduceOperation.calculResult()

        // Then
        XCTAssertEqual(reduceOperation.operationReduced, "Erreur")
    }

    func testGivenThereAreAdditionThenMultiplication_WhenOperationIsReduced_ThenCalculShouldBeginByTheMultiplication() {
        // Given
        let operation = "34 + 32 x 13"

        // When
        reduce(operation: operation)

        // Then
        if let intOperationReduced = Double(reduceOperation.operationReduced) {
            XCTAssertEqual(intOperationReduced, 34 + 32 * 13)
        }
    }

    func testGivenThereAreAdditionThenDivision_WhenOperationIsReduced_ThenCalculShouldBeginByTheDivision() {
        // Given
        let operation = "25 - 12 / 55"
        
        // When
        reduce(operation: operation)

        // Then
        if let intOperationReduced = Double(reduceOperation.operationReduced) {
            XCTAssertEqual(intOperationReduced, 25 - 12 / 55)
        }
    }

    func testGivenThereAreDividedThenMultiply_WhenOperationIsReduced_ThenCalculShouldBeginByTheDivisionThenTheMultiplication() {

        // Given
        let operation = "23 - 64 / 12 + 43 x 14"

        // When
        reduce(operation: operation)

        // Then
        if let intOperationReduced = Double(reduceOperation.operationReduced) {
            XCTAssertEqual(intOperationReduced, 23 - 64 / 12 + 43 * 14)
        }
    }

    func testGivenThereAreMultiplyThenDivided_WhenOperationIsReduced_ThenCalculShouldBeginByTheMultiplicationThenTheDivision() {
        // Given
        let operation = "2 + 2 x 2 / 2"

        // When
        reduce(operation: operation)

        // Then
        if let intOperationReduced = Double(reduceOperation.operationReduced) {
            XCTAssertEqual(intOperationReduced, 2 + 2 * 2 / 2)
        }
    }
}

