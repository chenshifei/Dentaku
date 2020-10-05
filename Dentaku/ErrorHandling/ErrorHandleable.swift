//
//  ErrorHandleable.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-10-05.
//

import UIKit
import DenCore
import FirebaseCrashlytics

protocol ErrorHandleable {
    var errorView: ErrorView? { get }
    func showError(_ errorCategory: ErrorCategory, level: ErrorLevel)
    func showError(_ text: String, level: ErrorLevel)
    func recordError(_ error: Error)
}

enum ErrorCategory {
    case network, data, input, other
    
    var errorMessage: String {
        switch self {
        case .network:
            return "Network error, please try again"
        case .data:
            return "Data error"
        case .input:
            return "Input error, please check and try again"
        default:
            return "Unknow error"
        }
    }
}

extension ErrorHandleable where Self: UIViewController {
    var errorView: ErrorView? {
        ErrorView(frame: CGRect.zero)
    }
    
    func showError(_ errorCategory: ErrorCategory, level: ErrorLevel = .error) {
        showError(errorCategory.errorMessage)
    }
    
    func showError(_ text: String, level: ErrorLevel = .error) {
        errorView?.show(text, level: level, from: self)
    }
    
    func recordError(_ error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
}
