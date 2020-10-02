//
//  ViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-21.
//

import UIKit

class InitialViewController: UIViewController {
    var calculator = Calculator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            switch segueId {
            case "ResultPageVCSegue":
                if let vc = segue.destination as? ResultPageViewController {
                    vc.calculator = calculator
                }
            case "KeyboardVCSegue":
                if let vc = segue.destination as? KeyboardViewController {
                    vc.calculator = calculator
                }
            default:
                return
            }
        }
    }

}

