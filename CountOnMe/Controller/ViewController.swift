//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textView: CalculatorTextView!
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var deleteButton: UIButton!
        
    // View Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        textView.calculatorDelegate = self
    }
    
    // View actions
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        
        if textView.expressionHaveResult {
            textView.text = ""
        }
        
        if numberText == "0" && textView.elements.last == "0" {
            return
        }
        
        if textView.elements.last == "0" {
            textView.deleteLastElement()
        }
        
        textView.text.append(numberText)
    }
    
    @IBAction func decimalTapped(_ sender: Any) {
        if textView.expressionHaveResult {
            textView.text = ""
        }

        if textView.elements.last == nil || !textView.canAddOperator {
            textView.text.append("0.")
        } else if textView.canAddOperator {
            textView.text.append(".")
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        if deleteButton.titleLabel?.text == "C" {
            textView.deleteLastElement()
        } else {
            textView.text.removeAll()
        }
    }
    
    @IBAction func tappedAdditionButton(_ sender: UIButton) {
        if textView.canAddOperator && !textView.expressionHaveResult{
            textView.text.append(" + ")
        } else {
            let alertVC = Alert.shared.createAnAlert(title: "Zéro!", message: "Un operateur est déja mis !")
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedSubstractionButton(_ sender: UIButton) {
        if textView.canAddOperator && !textView.expressionHaveResult {
            textView.text.append(" - ")
        } else {
            let alertVC = Alert.shared.createAnAlert(title: "Zéro!", message: "Un operateur est déja mis !")
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
        if textView.canAddOperator && !textView.expressionHaveResult {
            textView.text.append(" x ")
        } else {
            let alertVC = Alert.shared.createAnAlert(title: "Zéro!", message: "Un operateur est déja mis !")
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tappedDivisionButton(_ sender: UIButton) {
        if textView.canAddOperator && !textView.expressionHaveResult {
            textView.text.append(" / ")
        } else {
            let alertVC = Alert.shared.createAnAlert(title: "Zéro!", message: "Un operateur est déja mis !")
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    @IBAction func tappedEqualButton(_ sender: UIButton) {
        guard textView.expressionIsCorrect else {
            let alertVC = Alert.shared.createAnAlert(title: "Zéro!", message: "Entrez une expression correcte !")
            return self.present(alertVC, animated: true, completion: nil)
        }
        
        guard textView.expressionHaveEnoughElement else {
            let alertVC = Alert.shared.createAnAlert(title: "Zéro!", message: "Démarrez un nouveau calcul !")
            return self.present(alertVC, animated: true, completion: nil)
        }

        let reduceOperation = ReduceOperation(operationsToReduce: textView.elements)
        
        guard let operationsReduced = reduceOperation.operationsReduced else { return }
        
        operationsReduced == "Erreur" ?
           textView.text = operationsReduced : textView.text.append(" = \(operationsReduced)")
    }
}

extension ViewController: CalculatorTextViewDelegate {

    func textDidChange() {
        if textView.expressionHaveResult || textView.text == "" {
            deleteButton.setTitle("AC", for: .normal)
        } else {
            deleteButton.setTitle("C", for: .normal)
        }
    }
}
