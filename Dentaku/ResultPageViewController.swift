//
//  ResultPageViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-30.
//

import UIKit

class LCDScreenViewController: UIViewController {
    var index: Int = 0
    var isDisplayable = false
    var calculator: Calculator?
}

class ResultPageViewController: UIPageViewController {
    var calculator: Calculator? {
        didSet {
            contentVCs.forEach({ $0.calculator = calculator })
        }
    }
    var contentVCs = [LCDScreenViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentViewControllers()
        dataSource = self
        
        let initialVC = contentVCs[contentVCs.count / 2]
        setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
    }
    
    fileprivate func setupContentViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mapVC = storyboard.instantiateViewController(identifier: "MapResultViewController") as? MapResultViewController else {
            return
        }
        mapVC.index = 0
        mapVC.calculator = calculator
        contentVCs.append(mapVC)
        guard let calculationVC = storyboard.instantiateViewController(identifier: "CalculationResultViewController") as? CalculationResultViewController else {
            return
        }
        calculationVC.index = 1
        calculationVC.calculator = calculator
        contentVCs.append(calculationVC)
        guard let currencyVC = storyboard.instantiateViewController(identifier: "CurrencyResultViewController") as? CurrencyResultViewController else {
            return
        }
        currencyVC.index = 2
        currencyVC.calculator = calculator
        contentVCs.append(currencyVC)
    }
}

// MARK: - UIPageViewControllerDataSource

extension ResultPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextViewController(for: viewController, direction: .reverse)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nextViewController(for: viewController, direction: .forward)
    }
    
    fileprivate func nextViewController(for viewController: UIViewController, direction: UIPageViewController.NavigationDirection) -> UIViewController? {
       guard let vc = viewController as? LCDScreenViewController else {
            return nil
        }
        let nextIndex = direction == .forward ? vc.index + 1 : vc.index - 1
        guard contentVCs.indices.contains(nextIndex) else {
            return nil
        }
        return contentVCs[nextIndex]
    }
}
