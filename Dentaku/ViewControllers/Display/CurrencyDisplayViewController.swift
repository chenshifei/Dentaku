//
//  CurrencyResultViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-30.
//

import UIKit
import DenCore

class CurrencyDisplayViewController: DisplayUnitViewController {
    
    static let defaultExchangeRate: Double = 10000
    
    var exchangeRate = defaultExchangeRate
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var outputLabel: UILabel!
}

// MARK: - DisplayUnit

extension CurrencyDisplayViewController: DisplayUnit {
    
    var enabledOperatorKeys: [OperatorKey] {
        [DefaultKeys.Operator.add,
         DefaultKeys.Operator.substract,
         DefaultKeys.Operator.multiply,
         DefaultKeys.Operator.divide]
    }
    
    var customizedKey: CustomizedKey? {
        CustomizedKey(name: "rate?")
    }
    
    func numericOutputDelivered(_ result: ProcessorResult) {
        guard let number = result.0, result.1 == nil else {
            inputLabel.text = "Error"
            return
        }
        inputLabel.text = String(number)
    }
    
    func equationEvaluated(result: ProcessorResult) {
        guard let number = result.0, result.1 == nil else {
            inputLabel.text = "Error"
            return
        }
        
        inputLabel.text = String(number)
        outputLabel.text = "\(number * exchangeRate)"
    }
    
    func reset() {
        inputLabel.text = "0.0"
        outputLabel.text = "0.0"
    }
    
    func customizedKeyPressed() {
        DefaultEndpoints.Currency.fetchExchangeRates { [weak self] (result, error) in
            if let _ = error {
                self?.inputLabel.text = "Error"
                return
            }
            if let rate = Double(result?.data.rates["USD"] ?? "") {
                self?.exchangeRate = rate
            }
        }
    }
}
