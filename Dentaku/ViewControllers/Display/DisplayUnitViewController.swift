//
//  DisplayUnitViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-10-13.
//

import UIKit
import DenCore

class DisplayUnitViewController: UIViewController {
    
    weak var circuitBoard: CircuitBoard?
    
    var displayIndex: Int
    
    init?(coder: NSCoder, displayIndex: Int, circuitBoard: CircuitBoard) {
        self.displayIndex = displayIndex
        self.circuitBoard = circuitBoard
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.displayIndex = 0
        super.init(coder: coder)
    }
}
