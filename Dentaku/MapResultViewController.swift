//
//  MapResultViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-30.
//

import UIKit
import DenCore
import MapKit

class MapResultViewController: PageViewContentViewController {

    var inputedNumbers: [Double] = [0, 0]
    
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
}

extension MapResultViewController: DisplayUnit {
    
    var enabledOperatorKeys: [OperatorKey] {
        [DefaultKeys.Operator.add, DefaultKeys.Operator.substract]
    }
    
    var customizedKey: CustomizedKey? {
        CustomizedKey(name: "map")
    }
    
    func numericOutputDelivered(_ result: ProcessorResult) {
        guard let number = result.0, result.1 == nil else {
            displayLabel.text = "Error"
            return
        }
        displayLabel.text = String(number)
    }
    
    func equationEvaluated(result: ProcessorResult) {
        guard let number = result.0, result.1 == nil else {
            displayLabel.text = "Error"
            return
        }
        
        if inputedNumbers.count > 1 {
            inputedNumbers.removeFirst()
        }
        inputedNumbers.append(number)
        
        let latitude = inputedNumbers.count > 0 ? inputedNumbers[0] : 0
        let longitude = inputedNumbers.count > 1 ? inputedNumbers[1] : 0
        displayLabel.text = "\(latitude), \(longitude)"
    }
    
    func customizedKeyPressed() {
        guard inputedNumbers.count == 2 else {
            displayLabel.text = "Insufficient arguments"
            return
        }
        
        let location = CLLocation(latitude: inputedNumbers.first ?? 0, longitude: inputedNumbers.last ?? 0)
        AntennaDish().parseLocation(location) { [weak self] (result, error) in
            if let _ = error {
                self?.displayLabel.text = "Error"
            } else {
                guard let place = result?.first else { return }
                self?.displayPlacemark(place)
            }
        }
    }
    
    fileprivate func displayPlacemark(_ placemark: CLPlacemark) {
        resultLabel.text = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? "")"
    }
    
}
