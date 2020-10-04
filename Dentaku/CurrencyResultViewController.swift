//
//  CurrencyResultViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-30.
//

import UIKit
import DenCore

class CurrencyResultViewController: PageViewContentViewController {
    
    static let defaultExchangeRate: Double = 10000
    
    var exchangeRate = defaultExchangeRate
    @IBOutlet weak var btcLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension CurrencyResultViewController: DisplayUnit {
    
    var enabledOperatorKeys: [OperatorKey] {
        [DefaultKeys.Operator.add,
         DefaultKeys.Operator.substract,
         DefaultKeys.Operator.multiply,
         DefaultKeys.Operator.divide]
    }
    
    var customizedKey: CustomizedKey? {
        CustomizedKey(name: "btc")
    }
    
    func numericOutputDelivered(_ result: ProcessorResult) {
        guard let number = result.0, result.1 == nil else {
            btcLabel.text = "Error"
            return
        }
        btcLabel.text = String(number)
    }
    
    func equationEvaluated(result: ProcessorResult) {
        guard let number = result.0, result.1 == nil else {
            btcLabel.text = "Error"
            return
        }
        
        btcLabel.text = String(number)
        usdLabel.text = "\(number * exchangeRate)"
    }
    
    func reset() {
        btcLabel.text = "0.0"
        usdLabel.text = "0.0"
    }
    
    func customizedKeyPressed() {
        DefaultEndpoints.Currency.fetchExchangeRates { [weak self] (result, error) in
            if let _ = error {
                self?.btcLabel.text = "Error"
                return
            }
            if let rate = Double(result?.data.rates["USD"] ?? "") {
                self?.exchangeRate = rate
            }
        }
    }
}
