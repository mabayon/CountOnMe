//
//  ReduceOperation.swift
//  CountOnMe
//
//  Created by Mahieu Bayon on 13/11/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

class ReduceOperation {
    var operationsToReduce: String = "0" {
        didSet {
            createNotification(for: .OperationDidChange)
        }
    }
    
    var operationsReduced: String = ""
    
    var elements: [String] {
        return operationsToReduce.split(separator: " ").map { "\($0)" }
    }
    
    var isAnOperators: Bool {
        return elements.last == "+" || elements.last == "-" || elements.last == "x" || elements.last == "/"
    }
    
    var expressionIsCorrect: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }
    
    var expressionHaveEnoughElement: Bool {
        return elements.count >= 3
    }
    
    var canAddOperator: Bool {
        return elements.last != "+" && elements.last != "-" && elements.last != "x" && elements.last != "/"
    }
    
    var expressionHaveResult: Bool {
        return elements.firstIndex(of: "=") != nil
    }
    
    var isDecimal: Bool {
        return elements.last?.firstIndex(of: ".") != nil
    }
    
    func addNumber(newElement: String) {
        if elements.last == "0" {
            if newElement == "0" {
                return
            } else {
                operationsToReduce.removeLast()
                operationsToReduce += newElement
            }
        } else if expressionHaveResult || operationsReduced == "Erreur" {
            operationsToReduce = newElement
            operationsReduced = ""
        } else {
            operationsToReduce.append(newElement)
        }
    }
    
    func addOperator(newElement: String) {
        if canAddOperator && !expressionHaveResult {
            operationsToReduce.append(" " + newElement + " ")
        } else if expressionHaveResult {
            createNotification(for: .ErrorResult)
            return
        }
        createNotification(for: .ErrorOperator)
    }
    
    func addDecimal() {
        if expressionHaveResult || isAnOperators {
            operationsToReduce = expressionHaveResult ? "0." : operationsToReduce + "0."
        } else if !isAnOperators && !isDecimal {
            operationsToReduce += "."
        }
    }
        
    func delete() {
        if isAnOperators {
            operationsToReduce.removeLast(3)
        } else {
            operationsToReduce.removeLast()
        }
        
        if operationsToReduce.count == 0 || expressionHaveResult {
            operationsToReduce = "0"
        }
    }
    
    func calculResult() {
        guard !expressionHaveResult && operationsReduced != "Erreur" else {
            createNotification(for: .ErrorResult)
            return
        }
        
        guard expressionHaveEnoughElement && expressionIsCorrect else {
            createNotification(for: .ErrorExpression)
            return
        }
        
        reduce()
        operationsToReduce.append(" = ")
        operationsToReduce = operationsReduced != "Erreur" ?
            operationsToReduce + operationsReduced : operationsReduced
    }
    
    private func reduce() {
        var operationArray = elements
        // Iterate over operations while an operand still here
        while operationArray.count > 1 {

            var index: Array<String>.Index = 1

            var left = Double(operationArray[index - 1])!
            var operand = operationArray[index]
            var right = Double(operationArray[index + 1])!
            
            // If there is a priority change index
            if let firstIndex = checkForFirstPriority(in: operationArray) {
                index = firstIndex

                left = Double(operationArray[index - 1])!
                operand = operationArray[index]
                right = Double(operationArray[index + 1])!
            }
            
            let result: Double
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            case "x": result = multiply(numA: left, numB: right)
                
            case "/":
                
                do {
                    result = try divide(numA: left, numB: right)
                } catch CalculError.divisionByZero {
                    result = 0
                    operationsReduced = "Erreur"
                    return
                } catch {
                    result = 0
                    operationsReduced = "Erreur inattendue"
                    return
                }
                
            default: fatalError("Unknown operator !")
            }
            // Remove elements reduced and remplace them by the result
            operationArray = removeAndReplaceByResult(array: operationArray, index: index, result: "\(result)")
            
            // Check if the result is an integer
            let isInt = floor(result) == result
            // And if it is an integrer don't display decimal
            operationsReduced = isInt ? String(format: "%.0f", result) : String(result)
        }
    }
    
    private func checkForFirstPriority(in elements: [String]) -> Array<String>.Index? {
        let indexA = elements.firstIndex(of: "/")
        let indexB = elements.firstIndex(of: "x")
        
        if let indexA = indexA, let indexB = indexB {
            return indexA < indexB ? indexA : indexB
        } else if let indexA = indexA {
            return indexA
        } else if let indexB = indexB {
            return indexB
        }
        return nil
    }
    
    private func removeAndReplaceByResult(array: [String], index: Array<String>.Index, result: String) -> [String] {
        var newArray = array
        newArray.remove(at: index + 1)
        newArray.remove(at: index)
        newArray[index - 1] = result
        return newArray
    }
    
    private func multiply(numA: Double, numB: Double) -> Double {
        return numA * numB
    }
    
    private func divide(numA: Double, numB: Double) throws -> Double {
        guard numB != 0 else {
            throw CalculError.divisionByZero
        }
        return numA / numB
    }
    
    private func createNotification(for name: Notification.Name) {
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
    
    enum CalculError: Error {
        case divisionByZero
    }
}
