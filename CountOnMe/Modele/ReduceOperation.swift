//
//  ReduceOperation.swift
//  CountOnMe
//
//  Created by Mahieu Bayon on 13/11/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import Foundation

class ReduceOperation {
    private var operationsToReduce: [String]
    var operationsReduced: String?
    
    init(operationsToReduce: [String]) {
        self.operationsToReduce = operationsToReduce
        self.reduce()
    }
    
    private func reduce() {
        // Iterate over operations while an operand still here
        while operationsToReduce.count > 1 {
            
            var index: Array<String>.Index = 1
            
            var left = Float(operationsToReduce[index - 1])!
            var operand = operationsToReduce[index]
            var right = Float(operationsToReduce[index + 1])!
            
            if let firstIndex = checkForFirstPriority() {
                index = firstIndex

                left = Float(operationsToReduce[index - 1])!
                operand = operationsToReduce[index]
                right = Float(operationsToReduce[index + 1])!
            }
            
            let result: Float
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
            
            operationsToReduce = removeAndReplaceByResult(array: operationsToReduce, index: index, result: "\(result)")
            let isInt = floorf(result) == result
            operationsReduced = isInt ? String(format: "%.0f", result) : String(result)
        }
    }
    
    private func checkForFirstPriority() -> Array<String>.Index? {
        let indexA = operationsToReduce.firstIndex(of: "/")
        let indexB = operationsToReduce.firstIndex(of: "x")
        
        if let indexA = indexA, let indexB = indexB {
            return indexA < indexB ? indexA : indexB
        } else if let indexA = indexA {
            return indexA
        } else if let indexB = indexB {
            return indexB
        } else {
            return nil
        }
    }
    
    private func removeAndReplaceByResult(array: [String], index: Array<String>.Index, result: String) -> [String] {
        var newArray = array
        newArray.remove(at: index + 1)
        newArray.remove(at: index)
        newArray[index - 1] = result
        return newArray
    }
    
    private func multiply(numA: Float, numB: Float) -> Float {
        return numA * numB
    }
    
    private func divide(numA: Float, numB: Float) throws -> Float {
        guard numB != 0 else {
            throw CalculError.divisionByZero
        }
        return numA / numB
    }
    
    enum CalculError: Error {
        case divisionByZero
    }
}
