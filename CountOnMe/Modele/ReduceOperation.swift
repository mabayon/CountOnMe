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
            let left = Int(operationsToReduce[0])!
            let operand = operationsToReduce[1]
            let right = Int(operationsToReduce[2])!
            
            let result: Int
            switch operand {
            case "+": result = left + right
            case "-": result = left - right
            default: fatalError("Unknown operator !")
            }
            
            operationsToReduce = Array(operationsToReduce.dropFirst(3))
            operationsToReduce.insert("\(result)", at: 0)
            operationsReduced = String(result)
        }
    }
}
