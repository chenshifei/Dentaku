//
//  MapResultViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-30.
//

import UIKit
import DenCore
import CoreLocation
import Reachability

class MapDisplayViewController: DisplayUnitViewController {
    
    // MARK: Properties
    fileprivate static let defaultDisplayText = "0.0"
    fileprivate static let defaultResultText = "0,0"

    fileprivate var inputedNumbers: [Double] = [0, 0]
    fileprivate var reachability: Reachability?
    
    @IBOutlet fileprivate weak var displayLabel: UILabel!
    @IBOutlet fileprivate weak var resultLabel: UILabel!
    
    // MARK: Lifecycles
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
    fileprivate func displayInputNumbers() {
        let latitude = inputedNumbers.count > 0 ? inputedNumbers[0] : 0
        let longitude = inputedNumbers.count > 1 ? inputedNumbers[1] : 0
        resultLabel.text = "\(latitude), \(longitude)"
    }

    fileprivate func displayPlacemark(_ placemark: CLPlacemark) {
        resultLabel.text = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? "")"
    }
    
    fileprivate func fetchAddress() {
        guard inputedNumbers.count == 2 else {
            showError(.input)
            return
        }
        
        let location = CLLocation(latitude: inputedNumbers.first ?? 0, longitude: inputedNumbers.last ?? 0)
        AntennaDish().parseLocation(location) { [weak self] (result, error) in
            if let error = error {
                self?.recordError(error)
                self?.showError(.network)
            } else {
                guard let place = result?.first else {
                    self?.showError(.data)
                    return
                }
                self?.displayPlacemark(place)
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
                self?.showError("No network hence can't parse location", level: .warning)
            }
            try reachability?.startNotifier()
        } catch {
            recordError(error)
        }
        #endif
    }
    
}

// MARK: - DisplayUnit

extension MapDisplayViewController: DisplayUnit {
    
    var enabledOperatorKeys: [OperatorKey] {
        [DefaultKeys.Operator.add,
         DefaultKeys.Operator.substract]
    }
    
    var customizedKey: CustomizedKey? {
        CustomizedKey(name: "map")
    }
    
    func numericOutputDelivered(_ result: ProcessorResult) {
        switch result {
        case .failure:
            showError(.input)
        case .success(let number):
            displayLabel.text = "\(number)"
        }
    }
    
    func equationEvaluated(result: ProcessorResult) {
        switch result {
        case .failure:
            showError(.input)
        case .success(let number):
            displayLabel.text = "\(number)"
            
            if inputedNumbers.count > 1 {
                inputedNumbers.removeFirst()
            }
            inputedNumbers.append(number)
            
            displayInputNumbers()
        }
    }
    
    func reset() {
        displayLabel.text = MapDisplayViewController.defaultDisplayText
        resultLabel.text = MapDisplayViewController.defaultResultText
        inputedNumbers.removeAll()
    }
    
    func customizedKeyPressed() {
        fetchAddress()
    }
}

// MARK: - ErrorHandleable
extension MapDisplayViewController: ErrorHandleable {}
