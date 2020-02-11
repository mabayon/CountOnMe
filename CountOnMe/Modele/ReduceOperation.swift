//
//  ReduceOperation.swift
//  CountOnMe
//
//  Created by Mahieu Bayon on 13/11/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

class ReduceOperation {
    var operationToReduce: String = "0" {
        didSet {
            createNotification(for: .OperationDidChange)
        }
    }
    
    var operationReduced: String = ""
    
    var elements: [String] {
        return operationToReduce.split(separator: " ").map { "\($0)" }
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
                operationToReduce.removeLast()
                operationToReduce += newElement
            }
        } else if expressionHaveResult || operationReduced == "Erreur" {
            operationToReduce = newElement
            operationReduced = ""
        } else {
            operationToReduce.append(newElement)
        }
    }
    
    func addOperator(newElement: String) {
        if canAddOperator && !expressionHaveResult {
            operationToReduce.append(" " + newElement + " ")
        } else if expressionHaveResult {
            createNotification(for: .ErrorResult)
        } else {
            createNotification(for: .ErrorOperator)
        }
    }
    
    func addDecimal() {
        if expressionHaveResult || isAnOperators {
            operationToReduce = expressionHaveResult ? "0." : operationToReduce + "0."
        } else if !isAnOperators && !isDecimal {
            operationToReduce += "."
        }
    }
        
    func delete() {
        if isAnOperators {
            operationToReduce.removeLast(3)
        } else {
            operationToReduce.removeLast()
        }
        
        if operationToReduce.count == 0 || expressionHaveResult {
            operationToReduce = "0"
        }
    }
    
    func calculResult() {
        guard !expressionHaveResult && operationReduced != "Erreur" else {
            createNotification(for: .ErrorResult)
            return
        }
        
        guard expressionHaveEnoughElement && expressionIsCorrect else {
            createNotification(for: .ErrorExpression)
            return
        }
        
        reduce()
        operationToReduce.append(" = ")
        operationToReduce = operationReduced != "Erreur" ?
            operationToReduce + operationReduced : operationReduced
    }
    
    private func reduce() {
        var operationArray = elements
        // Iterate over operations while an operand still here
        while operationArray.count > 1 {

            // Check for priority
            let index: Array<String>.Index =
                operationArray.firstIndex { $0 == "/" || $0 == "x" } ?? 1

            let left = Double(operationArray[index - 1])!
            let operand = operationArray[index]
            let right = Double(operationArray[index + 1])!
                        
            let result: Double
            switch operand {
            case "+": result = add(numA: left, numB: right)
            case "-": result = subtract(numA: left, numB: right)
            case "x": result = multiply(numA: left, numB: right)
                
            case "/":
                
                do {
                    result = try divide(numA: left, numB: right)
                } catch CalculError.divisionByZero {
                    result = 0
                    operationReduced = "Erreur"
                    return
                } catch {
                    result = 0
                    operationReduced = "Erreur inattendue"
                    return
                }
                
            default: fatalError("Unknown operator !")
            }
            // Remove elements reduced and remplace them by the result
            operationArray = removeAndReplaceByResult(array: operationArray, index: index, result: "\(result)")
            
            // Check if the result is an integer
            let isInt = floor(result) == result
            // And if it is an integrer don't display decimal
            operationReduced = isInt ? String(format: "%.0f", result) : String(result)
        }
    }
        
    private func removeAndReplaceByResult(array: [String], index: Array<String>.Index, result: String) -> [String] {
        var newArray = array
        newArray.remove(at: index + 1)
        newArray.remove(at: index)
        newArray[index - 1] = result
        return newArray
    }
    
    private func add(numA: Double, numB: Double) -> Double {
        return numA + numB
    }
    
    private func subtract(numA: Double, numB: Double) -> Double {
        return numA - numB
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
