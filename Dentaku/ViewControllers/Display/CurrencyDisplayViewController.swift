//
//  CurrencyResultViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-30.
//

import UIKit
import DenCore
import FirebaseCrashlytics

class CurrencyDisplayViewController: DisplayUnitViewController {
    
    static let defaultDisplayText = "0.0"
    static let defaultExchangeRate: Double = 10600
    static let updateDateTextPrefix = "Exchange rate updated at: "
    
    var exchangeRate = defaultExchangeRate
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var updateTimeLabel: UILabel!
    
    fileprivate func formatUpdateTimeText() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let timeString = formatter.string(from: Date())
        updateTimeLabel.text = CurrencyDisplayViewController.updateDateTextPrefix + "\(timeString)"
    }
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
            self.showError(.input)
            return
        }
        inputLabel.text = String(number)
    }
    
    func equationEvaluated(result: ProcessorResult) {
        guard let number = result.0, result.1 == nil else {
            self.showError(.input)
            return
        }
        
        inputLabel.text = String(number)
        outputLabel.text = "\(number * exchangeRate)"
    }
    
    func reset() {
        inputLabel.text = CurrencyDisplayViewController.defaultDisplayText
        outputLabel.text = CurrencyDisplayViewController.defaultDisplayText
    }
    
    func customizedKeyPressed() {
        DefaultEndpoints.Currency.fetchExchangeRates { [weak self] (result, error) in
            if let error = error {
                self?.recordError(error)
                self?.showError("Currency update failed, may not be correct", level: .warning)
                return
            }
            if let rate = Double(result?.data.rates["USD"] ?? "") {
                self?.exchangeRate = rate
                self?.formatUpdateTimeText()
            } else {
                self?.showError(.data)
            }
        }
    }
}

// MARK: - ErrorHandleable
extension CurrencyDisplayViewController: ErrorHandleable {}
