//
//  ViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-21.
//

import UIKit

class InitialViewController: UIViewController {
    
    let circuitBoard = CircuitBoard()
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CircuitBoardPin {
            destinationVC.installOnCircuitBoard(circuitBoard)
        }
    }
}
