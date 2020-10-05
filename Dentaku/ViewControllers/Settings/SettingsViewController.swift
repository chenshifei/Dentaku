//
//  SettingsViewController.swift
//  Dentaku
//
//  Created by Shifei Chen on 2020-10-05.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var themeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let theme = Theme.fetchStoredTheme() {
            themeSwitch.isOn = theme == Theme.alternative.rawValue
        } else {
            themeSwitch.isOn = false
        }
    }
    
    @IBAction func handleSwitchValueDidChange(_ sender: UISwitch) {
        let theme = sender.isOn ? Theme.alternative : Theme.main
        Theme.storeTheme(theme)
    }
}
