//
//  CalculatorComponents.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-10-01.
//

import UIKit
import DenCore

protocol CircuitBoardSocket {
    var circuitBoard: CircuitBoard { get }
}

protocol CircuitBoardPin {
    func installOnCircuitBoard(_ circuitBoard: CircuitBoard)
}

protocol DisplayUnit {
    var enabledOperatorKeys: [OperatorKey] { get }
    
    func numericOutputDelivered(_ result: ProcessorResult)
    func equationEvaluated(result: ProcessorResult)
    
    var customizedKey: CustomizedKey? { get }
    var customizedKeyEnabled: Bool { get }
    func customizedKeyPressed()
}

protocol KeyboardUnit {
    func installCustomizedKeys(_ customizedButton: CustomizedKey)
    func customizedKey(enable: Bool)
    func installOperatorKeys(_ defaultOperatorButtons: [OperatorKey])
}

class CircuitBoard {
    internal var displayUnit: DisplayUnit? {
        didSet {
            if let displayUnit = displayUnit {
                installDisplayUnit(displayUnit)
            }
        }
    }
    internal var keyboardUnit: KeyboardUnit! {
        didSet {
            if let displayUnit = displayUnit {
                installDisplayUnit(displayUnit)
            }
        }
    }
    fileprivate var processor = Processor()
    
    fileprivate func installDisplayUnit(_ newDisplayUnit: DisplayUnit) {
        onFunctionKeyPressed(.clear)
        if let keyboard = keyboardUnit {
            keyboard.installOperatorKeys(newDisplayUnit.enabledOperatorKeys)
            if let customizedKey = newDisplayUnit.customizedKey {
                keyboard.installCustomizedKeys(customizedKey)
                keyboard.customizedKey(enable: newDisplayUnit.customizedKeyEnabled)
            }
        }
    }
    
    func customizedKey(enable: Bool) {
        if let keyboard = keyboardUnit {
            keyboard.customizedKey(enable: enable)
        }
    }
    
    func onNumpadKeyPressed(_ key: NumpadKey) {
        let result = processor.numpadKeyPressed(key: key)
        if let display = displayUnit {
            display.numericOutputDelivered(result)
        }
    }
    
    func onOperatorKeyPressed(_ key: OperatorKey) {
        let result = processor.operatorKeyPressed(key: key)
        if let display = displayUnit {
            display.numericOutputDelivered(result)
        }
    }
    
    func onCustomizedKeyPressed() {
        guard let display = displayUnit else { return }
        if let _ = display.customizedKey, display.customizedKeyEnabled {
            display.customizedKeyPressed()
        }
    }
    
    func onFunctionKeyPressed(_ key: FunctionKey) {
        let result = processor.functionKeyPressed(key: key)
        if let display = displayUnit {
            display.equationEvaluated(result: result)
        }
    }
}
