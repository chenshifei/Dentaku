//
//  CalculationResultViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-30.
//

import UIKit
import DenCore

class CalculationResultViewController: PageViewContentViewController {
    
    @IBOutlet weak var displayLabel: UILabel!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CalculationResultViewController: DisplayUnit {
    
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
    
    fileprivate func displayNumericResultOnScreen(_ result: ProcessorResult) {
        guard let numericResult = result.0 else { return }
        displayLabel.text = "\(numericResult)"
    }
    
}
