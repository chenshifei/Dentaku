//
//  KeyboardViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-30.
//

import UIKit
import DenCore

class KeyboardViewController: UIViewController {
    var calculator: Calculator?
    var installedOperatorKeys: [OperatorKey]? {
        didSet {
            operatorKeyButtons.forEach({ $0.isEnabled = false })
            guard let installedKeys = installedOperatorKeys else { return }
            zip(installedKeys, operatorKeyButtons).forEach({ key, button in
                button.setTitle(key.name, for: .normal)
                button.isEnabled = true
            })
        }
    }
    var installedCustomizedKey: CustomizedKey?
    @IBOutlet weak var operatorKeyButton1: UIButton!
    @IBOutlet weak var operatorKeyButton2: UIButton!
    @IBOutlet weak var operatorKeyButton3: UIButton!
    @IBOutlet weak var operatorKeyButton4: UIButton!
    @IBOutlet weak var operatorKeyButton5: UIButton!
    @IBOutlet weak var operatorKeyButton6: UIButton!
    @IBOutlet weak var customizedKeyButton: UIButton!
    var operatorKeyButtons: [UIButton] {
        [operatorKeyButton1, operatorKeyButton2, operatorKeyButton3, operatorKeyButton4, operatorKeyButton5, operatorKeyButton6]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calculator?.KeyboardUnit = self
    }
    
    @IBAction func handleNumpadKeyDidClick(_ sender: UIButton) {
        guard let calculator = calculator else { return }
        var key: NumpadKey
        switch sender.tag {
        case 0...9:
            key = NumpadKey.digit(underlyingValue: sender.tag)
        case 10:
            key = NumpadKey.separator
        default:
            return
        }
        calculator.onNumpadButtonPressed(key)
    }
    
    @IBAction func handleOperatorKeyDidClick(_ sender: UIButton) {
        guard let calculator = calculator else { return }
        guard let installedKey = installedOperatorKeys, installedKey.indices.contains(sender.tag)  else {
            return
        }
        let key = installedKey[sender.tag]
        calculator.onOperatorButtonPressed(key)
    }
    
    @IBAction func handleCustomizedKeyDidClick(_ sender: UIButton) {
        guard let calculator = calculator, let _ = installedCustomizedKey else {
            return
        }
        calculator.onCustomizedButtonPressed()
        
    }
    
    @IBAction func handleFunctionKeyDidClick(_ sender: UIButton) {
        guard let calculator = calculator else { return }
        switch sender.tag {
        case 0:
            calculator.onFunctionButtonPressed(.clear)
        case 1:
            calculator.onFunctionButtonPressed(.equal)
        default:
            return
        }
    }
}

extension KeyboardViewController: KeyboardUnit {
    func installCustomizedButton(_ customizedButton: CustomizedKey) {
        installedCustomizedKey = customizedButton
        customizedKeyButton.setTitle(customizedButton.name, for: .normal)
    }
    
    func enableCustomizedButton() {
        customizedKeyButton.isEnabled = true
    }
    
    func disableCustomizedButton() {
        customizedKeyButton.isEnabled = false
    }
    
    func installDefaultOperatorButtons(_ defaultOperatorButtons: [OperatorKey]) {
        installedOperatorKeys = defaultOperatorButtons
    }
}
