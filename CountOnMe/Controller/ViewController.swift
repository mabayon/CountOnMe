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
        textView.text = reduceOperation.operationToReduce
    }

    // MARK: Actions
    
    @IBAction func tappedNumberButton(_ sender: UIButton) {
        guard let numberText = sender.title(for: .normal) else {
            return
        }
        reduceOperation.addNumber(newElement: numberText)
    }
    
    @IBAction func decimalTapped(_ sender: Any) {
        reduceOperation.addDecimal()
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        reduceOperation.delete()
    }
    
    @IBAction func tappedOperators(_ sender: UIButton) {
        guard let operatorText = sender.title(for: .normal) else {
            return
        }
        
        reduceOperation.addOperator(newElement: operatorText)
    }
    
    @IBAction func tappedEqualButton(_ sender: UIButton) {
        reduceOperation.calculResult()
    }
    
    // MARK: Helper
    
    private func alert(title: String, message: String) {
        let alertVC = Alert.shared.createAnAlert(title: title, message: message)
        self.present(alertVC, animated: true, completion: nil)
    }
}
