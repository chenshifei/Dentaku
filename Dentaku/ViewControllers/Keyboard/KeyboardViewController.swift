//
//  KeyboardViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-30.
//

import UIKit
import DenCore

class KeyboardViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate weak var circuitBoard: CircuitBoard?
    
    fileprivate var installedOperatorKeys: [OperatorKey]? {
        didSet {
            operatorKeyButtons.forEach({
                $0.isEnabled = false
                $0.setTitle("", for: .normal)
            })
            guard let installedKeys = installedOperatorKeys else { return }
            zip(installedKeys, operatorKeyButtons).forEach({ key, button in
                button.setTitle(key.name, for: .normal)
                button.isEnabled = true
            })
        }
    }
    
    fileprivate var installedCustomizedKey: CustomizedKey?
    
    @IBOutlet fileprivate weak var operatorKeyButton1: UIButton!
    @IBOutlet fileprivate weak var operatorKeyButton2: UIButton!
    @IBOutlet fileprivate weak var operatorKeyButton3: UIButton!
    @IBOutlet fileprivate weak var operatorKeyButton4: UIButton!
    @IBOutlet fileprivate weak var operatorKeyButton5: UIButton!
    @IBOutlet fileprivate weak var operatorKeyButton6: UIButton!
    
    fileprivate var operatorKeyButtons: [UIButton] {
        [operatorKeyButton1,
         operatorKeyButton2,
         operatorKeyButton3,
         operatorKeyButton4,
         operatorKeyButton5,
         operatorKeyButton6]
    }
    
    @IBOutlet fileprivate weak var numpadKeyButton0: UIButton!
    @IBOutlet fileprivate weak var numpadKeyButton1: UIButton!
    @IBOutlet fileprivate weak var numpadKeyButton2: UIButton!
    @IBOutlet fileprivate weak var numpadKeyButton3: UIButton!
    @IBOutlet fileprivate weak var numpadKeyButton4: UIButton!
    @IBOutlet fileprivate weak var numpadKeyButton5: UIButton!
    @IBOutlet fileprivate weak var numpadKeyButton6: UIButton!
    @IBOutlet fileprivate weak var numpadKeyButton7: UIButton!
    @IBOutlet fileprivate weak var numpadKeyButton8: UIButton!
    @IBOutlet fileprivate weak var numpadKeyButton9: UIButton!
    @IBOutlet fileprivate weak var numpadKeyButton10: UIButton!
    
    fileprivate var numpadKeyButtons: [UIButton] {
        [numpadKeyButton0,
         numpadKeyButton1,
         numpadKeyButton2,
         numpadKeyButton3,
         numpadKeyButton4,
         numpadKeyButton5,
         numpadKeyButton6,
         numpadKeyButton7,
         numpadKeyButton8,
         numpadKeyButton9,
         numpadKeyButton10]
    }
    
    @IBOutlet fileprivate weak var clearKeyButton: UIButton!
    @IBOutlet fileprivate weak var equalKeyButton: UIButton!
    @IBOutlet fileprivate weak var customizedKeyButton: UIButton!
    
    // MARK: - Lifecycles
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        circuitBoard?.keyboardUnit = self
        
        applyTheme()
    }
    
    // MARK: - IBActions
    
    @IBAction fileprivate func handleNumpadKeyDidClick(_ sender: UIButton) {
        var key: NumpadKey
        switch sender.tag {
        case 0...9:
            key = NumpadKey.digit(underlyingValue: sender.tag)
        case 10:
            key = NumpadKey.separator
        default:
            return
        }
        circuitBoard?.onNumpadKeyPressed(key)
    }
    
    @IBAction fileprivate func handleOperatorKeyButtonDidClick(_ sender: UIButton) {
        guard let installedKey = installedOperatorKeys,
              installedKey.indices.contains(sender.tag)
        else { return }
        
        let key = installedKey[sender.tag]
        circuitBoard?.onOperatorKeyPressed(key)
    }
    
    @IBAction fileprivate func handleCustomizedKeyButtonDidClick(_ sender: UIButton) {
        guard let _ = installedCustomizedKey else {
            return
        }
        circuitBoard?.onCustomizedKeyPressed()
    }
    
    @IBAction fileprivate func handleFunctionKeyButtonDidClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            circuitBoard?.onFunctionKeyPressed(.clear)
        case 1:
            circuitBoard?.onFunctionKeyPressed(.equal)
        default:
            return
        }
    }
    
    // MARK: Private functions
    
    fileprivate func applyTheme() {
        operatorKeyButtons.forEach{ $0.backgroundColor = UIColor.appThemeColor(.secondaryBtnBackground) }
        numpadKeyButtons.forEach({ $0.backgroundColor = UIColor.appThemeColor(.btnBackground) })
        clearKeyButton.backgroundColor = UIColor.appThemeColor(.functionBtnBackground)
        equalKeyButton.backgroundColor = UIColor.appThemeColor(.functionBtnBackground)
        customizedKeyButton.backgroundColor = UIColor.appThemeColor(.secondaryBtnBackground)
    }
}

// MARK: - KeyboardUnit

extension KeyboardViewController: KeyboardUnit {
    
    func customizedKey(enable: Bool) {
        customizedKeyButton.isEnabled = enable
    }
    
    func installCustomizedKey(_ customizedKey: CustomizedKey) {
        installedCustomizedKey = customizedKey
        customizedKeyButton.setTitle(customizedKey.name, for: .normal)
    }
    
    func installOperatorKeys(_ operatorKeys: [OperatorKey]) {
        installedOperatorKeys = operatorKeys
    }
}

// MARK: - CircuitBoardPin

extension KeyboardViewController: CircuitBoardPin {
    
    func installOnCircuitBoard(_ circuitBoard: CircuitBoard) {
        self.circuitBoard = circuitBoard
    }

}
