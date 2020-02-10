//
//  Extension.swift
//  CountOnMe
//
//  Created by Mahieu Bayon on 10/02/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let ErrorResult = Notification.Name("ErrorResult")
    static let ErrorOperator = Notification.Name("ErrorOperator")
    static let ErrorExpression = Notification.Name("ErrorExpression")
    static let OperationDidChange = Notification.Name("OperationDidChange")
}
