//
//  CurrencyResultViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-30.
//

import UIKit
import DenCore
import Reachability

class CurrencyDisplayViewController: DisplayUnitViewController {
    
    // MARK: Properties
    fileprivate static let defaultDisplayText = "0.0"
    fileprivate static let defaultExchangeRate: Double = 10600
    fileprivate static let updateDateTextPrefix = "Exchange rate updated at: "
    
    fileprivate var exchangeRate = defaultExchangeRate
    fileprivate var reachability: Reachability?
    
    @IBOutlet fileprivate weak var inputLabel: UILabel!
    @IBOutlet fileprivate weak var outputLabel: UILabel!
    @IBOutlet fileprivate weak var updateTimeLabel: UILabel!
    
    // MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrency()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        circuitBoard?.displayUnit = self
        setupReachabilityListener()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reachability?.stopNotifier()
        super.viewWillDisappear(animated)
    }
    
    // MARK: Private functions
    
    fileprivate func formatUpdateTimeText() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        let timeString = formatter.string(from: Date())
        updateTimeLabel.text = CurrencyDisplayViewController.updateDateTextPrefix + "\(timeString)"
    }
    
    fileprivate func fetchCurrency() {
        DefaultEndpoints.Currency.fetchExchangeRates { [weak self] (result, error) in
            if let error = error {
                self?.recordError(error)
                self?.showError("Currency update failed, may be outdated", level: .warning)
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
    
    fileprivate func setupReachabilityListener() {
        // Reachability is not realiable on simulators
        #if !targetEnvironment(simulator)
        do {
            reachability = try Reachability()
            reachability?.whenReachable = { [weak self] _ in
                self?.circuitBoard?.customizedKey(enable: true)
            }
            reachability?.whenReachable = { [weak self] _ in
                self?.circuitBoard?.customizedKey(enable: false)
                self?.showError("No network, currency rate may be outdated", level: .warning)
            }
            try reachability?.startNotifier()
        } catch {
            recordError(error)
        }
        #endif
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
        switch result {
        case .failure:
            showError(.input)
        case .success(let number):
            inputLabel.text = "\(number)"
        }
    }
    
    func equationEvaluated(result: ProcessorResult) {
        switch result {
        case .failure:
            showError(.input)
        case .success(let number):
            inputLabel.text = "\(number)"
            outputLabel.text = "\(number * exchangeRate)"
        }
    }
    
    func reset() {
        inputLabel.text = CurrencyDisplayViewController.defaultDisplayText
        outputLabel.text = CurrencyDisplayViewController.defaultDisplayText
    }
    
    func customizedKeyPressed() {
        fetchCurrency()
    }
}

// MARK: - ErrorHandleable
extension CurrencyDisplayViewController: ErrorHandleable {}
