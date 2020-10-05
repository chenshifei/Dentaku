//
//  MapResultViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-30.
//

import UIKit
import DenCore
import CoreLocation
import FirebaseCrashlytics

class MapDisplayViewController: DisplayUnitViewController {
    
    fileprivate static let defaultDisplayText = "0.0"
    fileprivate static let defaultResultText = "0,0"

    fileprivate var inputedNumbers: [Double] = [0, 0]
    
    @IBOutlet fileprivate weak var displayLabel: UILabel!
    @IBOutlet fileprivate weak var resultLabel: UILabel!
    
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
        guard let number = result.0, result.1 == nil else {
            showError(.input)
            return
        }
        displayLabel.text = String(number)
    }
    
    func equationEvaluated(result: ProcessorResult) {
        guard let number = result.0, result.1 == nil else {
            showError(.input)
            return
        }
        displayLabel.text = String(number)
        
        if inputedNumbers.count > 1 {
            inputedNumbers.removeFirst()
        }
        inputedNumbers.append(number)
        
        displayInputNumbers()
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
