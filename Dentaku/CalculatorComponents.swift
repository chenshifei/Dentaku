//
//  CalculatorComponents.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-10-01.
//

import Foundation
import DenCore

protocol DisplayUnit {
    var allowedDefaultOperatorButtons: [OperatorKey] { get }
    
    func numericOutputDelivered(_ result: ProcessorResult)
    func equationEvaluated(result: ProcessorResult)
}

protocol ExtendedDisplayUnit: DisplayUnit {
    var customizedButton: CustomizedKey? { get }
    var customizedButtonEnabled: Bool { get set }
    func customizedButtonPressed()
}

protocol KeyboardUnit {
    func installCustomizedButton(_ customizedButton: CustomizedKey)
    func enableCustomizedButton()
    func disableCustomizedButton()
    func installDefaultOperatorButtons(_ defaultOperatorButtons: [OperatorKey])
}

class Calculator {
    internal var displayUnit: DisplayUnit?
    internal var keyboardUnit: KeyboardUnit? {
        didSet {
            if let displayUnit = displayUnit {
                installDisplayUnit(displayUnit)
            }
        }
    }
    fileprivate var processor = Processor()
    
    func installDisplayUnit(_ newDisplayUnit: DisplayUnit) {
        onFunctionButtonPressed(.clear)
        if let keyboard = keyboardUnit {
            keyboard.installDefaultOperatorButtons(newDisplayUnit.allowedDefaultOperatorButtons)
            if let newDisplayUnit = newDisplayUnit as? ExtendedDisplayUnit {
                if let customizedKey = newDisplayUnit.customizedButton {
                    keyboard.installCustomizedButton(customizedKey)
                }
                if newDisplayUnit.customizedButtonEnabled {
                    keyboard.enableCustomizedButton()
                } else {
                    keyboard.disableCustomizedButton()
                }
            }
        }
        displayUnit = newDisplayUnit
    }
    
    func disableCustomizedButton() {
        if let keyboard = keyboardUnit {
            keyboard.disableCustomizedButton()
        }
    }
    
    func enableCustomizedButton() {
        if let keyboard = keyboardUnit {
            keyboard.enableCustomizedButton()
        }
    }
    
    func onNumpadButtonPressed(_ key: NumpadKey) {
        let result = processor.numpadKeyPressed(key: key)
        if let display = displayUnit {
            display.numericOutputDelivered(result)
        }
    }
    
    func onOperatorButtonPressed(_ key: OperatorKey) {
        let result = processor.operatorKeyPressed(key: key)
        if let display = displayUnit {
            display.numericOutputDelivered(result)
        }
    }
    
    func onCustomizedButtonPressed() {
        guard let display = displayUnit as? ExtendedDisplayUnit else { return }
        if let _ = display.customizedButton, display.customizedButtonEnabled {
            display.customizedButtonPressed()
        }
    }
    
    func onFunctionButtonPressed(_ key: FunctionKey) {
        let result = processor.functionKeyPressed(key: key)
        if let display = displayUnit {
            display.equationEvaluated(result: result)
        }
    }
}
