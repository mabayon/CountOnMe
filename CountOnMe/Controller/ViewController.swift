//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var deleteButton: UIButton!
        
    let reduceOperation = ReduceOperation()
    
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
    }
    
    // MARK: Notification
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(errorOperator), name: .ErrorOperator, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(errorResult), name: .ErrorResult, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(errorExpression), name: .ErrorExpression, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(operationDidChange), name: .OperationDidChange, object: nil)

    }
    
    @objc private func errorOperator() {
        alert(title: "Zéro!", message: "Un operateur est déja mis !")
    }
    
    @objc private func errorResult() {
        alert(title: "Zéro!", message: "Démarrez un nouveau calcul !")
    }

    @objc private func errorExpression() {
        alert(title: "Zéro!", message: "Entrez une expression correcte !")
    }
    
    @objc private func operationDidChange() {
        textView.text = reduceOperation.operationsToReduce
    }

    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
//        // If there is a result put textView = "0"
//        if textView.expressionHaveResult || textView.text == "Erreur" {
//            textView.text = "0"
//        }
//
//        // If there is already a zero return
//        if numberText == "0" && textView.elements.last == "0" {
//            return
//        }
//
//        // If element is 0 remplace it
//        if textView.elements.last == "0" {
//            textView.deleteLastElement()
//        }
        
        reduceOperation.addNumber(newElement: numberText)
    }
    
    @IBAction func decimalTapped(_ sender: Any) {
//        // If there is a result reset textView
//        if textView.expressionHaveResult {
//            textView.text = "0"
//        }
//        // If there is already a number (canAddOperator) add . else add 0.
//        _ = textView.canAddOperator ? textView.text.append(".") : textView.text.append("0.")
        reduceOperation.addDecimal()
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
//        if deleteButton.titleLabel?.text == "C" {
//            _ = textView.elements.count == 1 ? textView.text = "0" : textView.deleteLastElement()
//        } else {
//            textView.text = "0"
//        }
        reduceOperation.delete()
    }
    
    private func alert(title: String, message: String) {
        let alertVC = Alert.shared.createAnAlert(title: title, message: message)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func tappedOperators(_ sender: UIButton) {
        guard let operatorText = sender.title(for: .normal) else {
            return
        }

        reduceOperation.addOperator(newElement: operatorText)
    }
    
//    @IBAction func tappedAdditionButton(_ sender: UIButton) {
//        if textView.canAddOperator && !textView.expressionHaveResult {
//            textView.text.append(" + ")
//        } else {
//            alert(title: "Zéro!", message: "Un operateur est déja mis !")
//        }
//    }
//    
//    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
//        if textView.canAddOperator && !textView.expressionHaveResult {
//            textView.text.append(" - ")
//        } else {
//            alert(title: "Zéro!", message: "Un operateur est déja mis !")
//        }
//    }
//    
//    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
//        if textView.canAddOperator && !textView.expressionHaveResult {
//            textView.text.append(" x ")
//        } else {
//            alert(title: "Zéro!", message: "Un operateur est déja mis !")
//        }
//    }
//    
//    @IBAction func tappedDivisionButton(_ sender: UIButton) {
//        if textView.canAddOperator && !textView.expressionHaveResult {
//            textView.text.append(" / ")
//        } else {
//            alert(title: "Zéro!", message: "Un operateur est déja mis !")
//        }
//    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        reduceOperation.calculResult()
        
//        guard textView.expressionIsCorrect else {
//            return alert(title: "Zéro!", message: "Entrez une expression correcte !")
//        }
//
//        guard textView.expressionHaveEnoughElement && !textView.expressionHaveResult else {
//            return alert(title: "Zéro!", message: "Démarrez un nouveau calcul !")
//        }

//        let reduceOperation = ReduceOperation(operationsToReduce: textView.elements)
//
//        guard let operationsReduced = reduceOperation.operationsReduced else { return }
//
//        operationsReduced == "Erreur" ?
//           textView.text = operationsReduced : textView.text.append(" = \(operationsReduced)")
    }
}

//extension ViewController: CalculatorTextViewDelegate {
//
//    func textDidChange() {
//        if textView.expressionHaveResult || textView.text == "0" {
//            deleteButton.setTitle("AC", for: .normal)
//        } else {
//            deleteButton.setTitle("C", for: .normal)
//        }
//    }
//}
