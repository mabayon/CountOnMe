//
//  CalculatorTextView.swift
//  CountOnMe
//
//  Created by Mahieu Bayon on 19/11/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

protocol CalculatorTextViewDelegate {
    func textDidChange()
}

class CalculatorTextView: UITextView {

    var calculatorDelegate: CalculatorTextViewDelegate?
    
    var elements: [String] {
        return self.text.split(separator: " ").map { "\($0)" }
    }
    
    var isAnOperators: Bool {
        return elements.last == "+" || elements.last == "-" || elements.last == "x" || elements.last == "/"
    }
    
    // Error check computed variables
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
        return self.text.firstIndex(of: "=") != nil
    }

    override var text: String! {
        didSet {
            calculatorDelegate?.textDidChange()
        }
    }
    
    func deleteLastElement() {
        var copyElements = elements
        
        if !copyElements.isEmpty {
            copyElements.removeLast()
            self.text = ""
            for element in copyElements {
                self.text.append(element + " ")
            }
        }
    }
}
