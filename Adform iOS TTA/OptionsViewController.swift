//
//  OptionsViewController.swift
//  Adform iOS TTA
//
//  Created by Adform on 2017-11-10.
//  Copyright © 2017 Adform. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {

    //MARK: Properies
    @IBOutlet weak var safariVcSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func showMessageAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let dialogue = UIAlertController(title: title, message: message, preferredStyle: .alert);
        dialogue.addAction(UIAlertAction(title: "OK", style: .default, handler: handler));
        self.present(dialogue, animated: true, completion: nil);
    }
    @IBAction func clearDataTapped(_ sender: CustomButton) {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        showMessageAlert(title: "App Data Cleared", message: "App will now run like on the first launch", handler: nil);
    }
    @IBAction func safariVcSwitchTapped(_ sender: UISwitch) {
        if sender.isOn {
            AdformTrackingSDK.sharedInstance().setSafariControllerEnabled(true);
        } else {
            AdformTrackingSDK.sharedInstance().setSafariControllerEnabled(false);
        }
    }
    
}
