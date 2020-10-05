//
//  ViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-21.
//

import UIKit
import DenCore

class InitialViewController: UIViewController {
    
    fileprivate let circuitBoard = CircuitBoard()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CircuitBoardPin {
            destinationVC.installOnCircuitBoard(circuitBoard)
        }
    }
}
