//
//  CalculationResultViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-30.
//

import UIKit
import DenCore

class CalculationResultViewController: LCDScreenViewController {
    
    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isDisplayable = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        calculator?.installDisplayUnit(self)
    }
    

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
    
    var allowedDefaultOperatorButtons: [OperatorKey] {
        [DefaultKeys.Operator.add,
         DefaultKeys.Operator.substract,
         DefaultKeys.Operator.multiply,
         DefaultKeys.Operator.divide,
         DefaultKeys.Operator.sin,
         DefaultKeys.Operator.cos]
    }
    
    func numericOutputDelivered(_ result: ProcessorResult) {
        guard let value = result.0 else { return }
        displayLabel.text = "\(value)"
    }
    
    func equationEvaluated(result: ProcessorResult) {
        guard let value = result.0 else { return }
        displayLabel.text = "\(value)"
    }
    
    
}
