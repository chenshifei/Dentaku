//
//  Theme.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-10-05.
//

import UIKit

enum AssetsColor: String {
    case text
    case noteText
    case background
    case btnBackground
    case secondaryBtnBackground
    case secondaryBtnBackgroundDisabled
    case functionBtnBackground
    case keyboardBackground
    case error
    case warning
}

enum Theme: String {
    fileprivate static let userDefaultThemeKey = "theme"
    
    case main, alternative
    
    static func storeTheme(_ theme:Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: Theme.userDefaultThemeKey)
        UserDefaults.standard.synchronize()
    }
    
    static func fetchStoredTheme() -> String? {
        return UserDefaults.standard.string(forKey: Theme.userDefaultThemeKey)
    }
}

extension UIColor {
    static func appThemeColor(_ name: AssetsColor) -> UIColor? {
        let theme = Theme.fetchStoredTheme() ?? Theme.main.rawValue
        let colorName = theme + "-" + name.rawValue
        return UIColor(named: colorName)
    }
}
