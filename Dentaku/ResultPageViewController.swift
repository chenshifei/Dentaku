//
//  ResultPageViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-09-30.
//

import UIKit
import DenCore

class PageViewContentViewController: UIViewController {
    var displayIndex: Int
    
    init?(coder: NSCoder, displayIndex: Int) {
        self.displayIndex = displayIndex
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        self.displayIndex = 0
        super.init(coder: coder)
    }
}

class ResultPageViewController: UIPageViewController {
    
    weak var circuitBoard: CircuitBoard?
    
    var contentVCs = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContentViewControllers()
        dataSource = self
        delegate = self
        
        let initialVC = contentVCs[contentVCs.count / 2]
        setViewControllers([initialVC], direction: .forward, animated: false, completion: nil)
        circuitBoard?.displayUnit = initialVC as? DisplayUnit
    }
    
    fileprivate func setupContentViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapVC = storyboard.instantiateViewController(identifier: "MapResultViewController", creator: { coder in
            MapResultViewController(coder: coder, displayIndex: 0)
        })
        contentVCs.append(mapVC)
        let calculationVC = storyboard.instantiateViewController(identifier: "CalculationResultViewController", creator: { coder in
            CalculationResultViewController(coder: coder, displayIndex: 1)
        })
        contentVCs.append(calculationVC)
        let currencyVC = storyboard.instantiateViewController(identifier: "CurrencyResultViewController", creator: { coder in
            CurrencyResultViewController(coder: coder, displayIndex: 2)
        })
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
        guard let vc = viewController as? PageViewContentViewController else { return nil }
        let nextIndex = direction == .forward ? vc.displayIndex + 1 : vc.displayIndex - 1
        guard contentVCs.indices.contains(nextIndex) else {
            return nil
        }
        return contentVCs[nextIndex]
    }
}

extension ResultPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVC = pageViewController.viewControllers?.first as? DisplayUnit else {
            return
        }
        
        circuitBoard?.displayUnit = currentVC
    }
}

extension ResultPageViewController: CircuitBoardPin {
    func installOnCircuitBoard(_ circuitBoard: CircuitBoard) {
        self.circuitBoard = circuitBoard
    }
}
