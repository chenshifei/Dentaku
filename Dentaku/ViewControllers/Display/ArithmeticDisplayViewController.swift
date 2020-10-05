//
//  CalculationResultViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-30.
//

import UIKit
import DenCore
import FirebaseCrashlytics

class ArithmeticDisplayViewController: DisplayUnitViewController {
    
    static let defaultDisplayText = "0.0"
    
    @IBOutlet weak var displayLabel: UILabel!

}

// MARK: - DisplayUnit

extension ArithmeticDisplayViewController: DisplayUnit {
    
    var customizedKey: CustomizedKey? {
        nil
    }
    
    var customizedKeyEnabled: Bool {
        false
    }
    
    func customizedKeyPressed() {}
    
    var enabledOperatorKeys: [OperatorKey] {
        [DefaultKeys.Operator.add,
         DefaultKeys.Operator.substract,
         DefaultKeys.Operator.multiply,
         DefaultKeys.Operator.divide,
         DefaultKeys.Operator.sin,
         DefaultKeys.Operator.cos]
    }
    
    func numericOutputDelivered(_ result: ProcessorResult) {
        displayNumericResultOnScreen(result)
    }
    
    func equationEvaluated(result: ProcessorResult) {
        displayNumericResultOnScreen(result)
    }
    
    func reset() {
        displayLabel.text = ArithmeticDisplayViewController.defaultDisplayText
    }
    
    fileprivate func displayNumericResultOnScreen(_ result: ProcessorResult) {
        if let error = result.1 {
            recordError(error)
            showError(.input)
        } else if let number = result.0 {
            displayLabel.text = "\(number)"
        } else {
            showError(.input)
        }
    }
}

// MARK: - ErrorHandleable
extension ArithmeticDisplayViewController: ErrorHandleable {}
