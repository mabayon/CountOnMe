//
//  Alert.swift
//  CountOnMe
//
//  Created by Mahieu Bayon on 16/11/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class Alert {
    static let shared = Alert()
    
    // Create an alert with a custom message
    func createAnAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        return alert
    }
}
