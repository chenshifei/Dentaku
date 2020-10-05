//
//  ErrorView.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-10-05.
//

import UIKit

enum ErrorLevel {
    case warning, error
}

class ErrorView: UIView {
    
    static let viewTag = 458
    static let defaultHeight: CGFloat = 30.0
    static let animationDuration = 0.5
    static let displayDuration = 3.0

    fileprivate var textLabel: UILabel
    
    override init(frame: CGRect) {
        textLabel = UILabel()
        textLabel.textColor = .white
        textLabel.font = .preferredFont(forTextStyle: .caption2)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        super.init(frame: frame)
        addSubview(textLabel)
        translatesAutoresizingMaskIntoConstraints = false
        tag = ErrorView.viewTag
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20),
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        super.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(_ text: String = "", level: ErrorLevel = .error, from viewController: UIViewController) {
        viewWithTag(ErrorView.viewTag)?.removeFromSuperview()
        
        viewController.view.addSubview(self)
        guard let superView = superview else { return }
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor),
            topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor),
            trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor),
            heightAnchor.constraint(equalToConstant: ErrorView.defaultHeight)
        ])
        superView.sendSubviewToBack(self)
        alpha = 0
        textLabel.text = text
        switch level {
        case .warning:
            backgroundColor = UIColor.appThemeColor(.warning)
        default:
            backgroundColor = UIColor.appThemeColor(.error)
        }
        superview?.bringSubviewToFront(self)
        
        UIView.animate(withDuration: ErrorView.animationDuration) {
            self.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: ErrorView.animationDuration, delay: ErrorView.displayDuration) {
                self.alpha = 0
            }
        }

    }
}
