//
//  CalculatorPropagatingSegue.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-10-04.
//

import UIKit
import DenCore

class CalculatorPropagatingSegue: UIStoryboardSegue {
    override func perform() {
        if let source = source as? CircuitBoardSocket, let target = destination as? CircuitBoardPin {
            target.installOnCircuitBoard(source.circuitBoard)
        }
        super.perform()
    }
}
