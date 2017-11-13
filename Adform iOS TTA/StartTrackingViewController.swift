//
//  ViewController.swift
//  Adform iOS TTA
//
//  Created by Adform on 2017-10-25.
//  Copyright © 2017 Adform. All rights reserved.
//

import UIKit


class StartTrackingViewController: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet weak var pmField: UITextField!
    @IBOutlet weak var appNameField: UITextField!
    private enum MyError: Error {
        case FoundNil(String)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        pmField.delegate = self;
        appNameField.delegate = self;
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(StartTrackingViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    //MARK: Actions
    func showMessageAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let dialogue = UIAlertController(title: title, message: message, preferredStyle: .alert);
        dialogue.addAction(UIAlertAction(title: "OK", style: .default, handler: handler));
        self.present(dialogue, animated: true, completion: nil);
    }
    @objc func didTapView() {
        self.view.endEditing(true);
    }
    @IBAction func sendTracking(_ sender: UIButton) {
        self.view.endEditing(true);
        do {
            guard let pmValue = Int(pmField.text!) else {
                throw MyError.FoundNil("invalid pm")
            };
            let appName = appNameField.text!;
            AdformTrackingSDK.sharedInstance().setAppName(appName);
            AdformTrackingSDK.sharedInstance().startTracking(pmValue);
        } catch {
            print("invalid pm");
            showMessageAlert(title: "Error", message: "You must enter a valid tracking ID", handler: nil);
            return;
        }
        showMessageAlert(title: "Success", message: "Tracking data successfully sent", handler: nil);
    }
}

