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
    
    // MARK: Properties
    fileprivate static let defaultDisplayText = "0.0"
    
    @IBOutlet fileprivate weak var displayLabel: UILabel!
    
    // MARK: Lifecycles
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        circuitBoard?.displayUnit = self
    }
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
        switch result {
        case .failure(let error):
            recordError(error)
            showError(.input)
        case .success(let number):
            displayLabel.text = "\(number)"
        }
    }
}

// MARK: - ErrorHandleable
extension ArithmeticDisplayViewController: ErrorHandleable {}
