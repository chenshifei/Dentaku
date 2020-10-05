//
//  ResultPageViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-30.
//

import UIKit
import DenCore

// MARK: - DisplayUnitViewController

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

// MARK: - DisplayPageViewController

class DisplayPageViewController: UIPageViewController {
    
    // MARK: Properties
    fileprivate weak var circuitBoard: CircuitBoard?
    
    fileprivate var contentVCs = [UIViewController]()
    
    // MARK: Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentViewControllers()
        dataSource = self
        
        let initialVC = contentVCs[contentVCs.count / 2]
        setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
    }
    
    // MARK: Private functions
    fileprivate func setupContentViewControllers() {
        guard let circuitBoard = circuitBoard else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapVC = storyboard.instantiateViewController(identifier: "MapResultViewController", creator: { coder in
            MapDisplayViewController(coder: coder, displayIndex: 0, circuitBoard: circuitBoard)
        })
        contentVCs.append(mapVC)
        let calculationVC = storyboard.instantiateViewController(identifier: "CalculationResultViewController", creator: { coder in
            ArithmeticDisplayViewController(coder: coder, displayIndex: 1, circuitBoard: circuitBoard)
        })
        contentVCs.append(calculationVC)
        let currencyVC = storyboard.instantiateViewController(identifier: "CurrencyResultViewController", creator: { coder in
            CurrencyDisplayViewController(coder: coder, displayIndex: 2, circuitBoard: circuitBoard)
        })
        contentVCs.append(currencyVC)
    }
}

// MARK: - UIPageViewControllerDataSource

extension DisplayPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextViewController(for: viewController, direction: .reverse)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nextViewController(for: viewController, direction: .forward)
    }
    
    fileprivate func nextViewController(for viewController: UIViewController, direction: UIPageViewController.NavigationDirection) -> UIViewController? {
        guard let vc = viewController as? DisplayUnitViewController else { return nil }
        let nextIndex = direction == .forward ? vc.displayIndex + 1 : vc.displayIndex - 1
        guard contentVCs.indices.contains(nextIndex) else {
            return nil
        }
        return contentVCs[nextIndex]
    }
}

// MARK: - CircuitBoardPin

extension DisplayPageViewController: CircuitBoardPin {
    func installOnCircuitBoard(_ circuitBoard: CircuitBoard) {
        // Workaround for storyboard dependency injection
        self.circuitBoard = circuitBoard
    }
}
