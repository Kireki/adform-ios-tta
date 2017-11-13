//
//  CustomTrackingController.swift
//  Adform iOS TTA
//
//  Created by Adform on 2017-11-07.
//  Copyright © 2017 Adform. All rights reserved.
//

import UIKit

class CustomTrackingViewController: UIViewController, UITextFieldDelegate {
    //MARK: Properties
    @IBOutlet weak var orderVarStack: UIStackView!
    @IBOutlet weak var productStack: UIStackView!
    @IBOutlet weak var trackingIdField: UITextField!
    @IBOutlet weak var sectionNameField: UITextField!
    private enum MyError: Error {
        case FoundNil(String)
    }
    //MARK: helpers
    private func makeVarControlItem() {
        let newVarControl = VarControl(parentController: self, type: "order");
        orderVarStack.addArrangedSubview(newVarControl);
    }
    private func makeProductControlItem() {
        let newProductControl = ProductControl(parentController: self);
        productStack.addArrangedSubview(newProductControl);
    }
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(CustomTrackingViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        self.trackingIdField.keyboardType = .numberPad;
    }
    
    //MARK: Actions
    func showMessageAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
        let dialogue = UIAlertController(title: title, message: message, preferredStyle: .alert);
        dialogue.addAction(UIAlertAction(title: "OK", style: .default, handler: handler));
        self.present(dialogue, animated: true, completion: nil);
    }
    @IBAction func addOrderVarButton(_ sender: UIButton) {
        makeVarControlItem();
    }
    @IBAction func addProductButton(_ sender: UIButton) {
        makeProductControlItem();
    }
    @IBAction func sendTrackPoint(_ sender: CustomButton) {
        self.view.endEditing(true);
        if (self.trackingIdField.text?.isEmpty)! {
            showMessageAlert(title: "Error", message: "Tracking ID can't be empty", handler: nil);
            return;
        }
        let trackingId = Int(self.trackingIdField.text!)!;
        if (self.sectionNameField.text?.isEmpty)! {
            showMessageAlert(title: "Error", message: "Section name must be provided", handler: nil);
            return;
        }
        let sectionName = self.sectionNameField.text;
        let trackPoint = AFTrackPoint(trackPoint: trackingId);
        let adfOrder = self.formatOrderVars();
        let adfProducts = self.formatProductVars();
        trackPoint?.setSectionName(sectionName);
        trackPoint?.setOrder(adfOrder);
        trackPoint?.setProducts(adfProducts);
        AdformTrackingSDK.sharedInstance().send(trackPoint);
        showMessageAlert(title: "Success", message: "Tracking data sent", handler: nil);
    }
    @objc func didTapView() {
        self.view.endEditing(true);
    }
    private func formatOrderVars() -> AFOrder {
        var orderDict = Dictionary<String, String>();
        let orderVarElements = self.orderVarStack.subviews.filter{$0 is VarControl};
        for element in orderVarElements as! [VarControl] {
            if element.currentVar == "+ Var" {
                continue;
            }
            orderDict[element.currentVar] = element.currentValue;
        }
        let adfOrder = AFOrder();
        for (key, value) in orderDict {
            let svMatch = matches(for: "^sv\\d{1,3}$", in: key);
            let svnMatch = matches(for: "^svn\\d{1,3}$", in: key);
            if svMatch.count > 0 {
                let sysVarKey = matches(for: "\\d{1,3}$", in: svMatch[0]);
                adfOrder.setSystemVariable(value, forKey: Int(sysVarKey[0])!);
            } else if svnMatch.count > 0 {
                let sysVarKey = matches(for: "\\d{1,3}$", in: svnMatch[0]);
                do {
                    guard let numericValue = Float(value) else {
                        throw MyError.FoundNil("invalid svn");
                    }
                    adfOrder.setNumericSystemVariable(numericValue as NSNumber, forKey: Int(sysVarKey[0])!)
                } catch {
                    print("invalid svn");
                }
            } else {
                if (key == "sale") {
                    do {
                        guard let sales = Float(value) else {
                            throw MyError.FoundNil("invalid sales");
                        }
                        adfOrder.sale = sales;
                    } catch {
                        print("invalid sales")
                    }
                } else if (key == "basketSize") {
                    do {
                        guard let basketSize = Int(value) else {
                            throw MyError.FoundNil("invalid basket size");
                        }
                        adfOrder.basketSize = basketSize;
                    } catch {
                        print("invalid basketSize");
                    }
                } else {
                    adfOrder.setValue(value, forKey: key);
                }
            }
            
        }
        return adfOrder;
    }
    
    private func formatProductVars() -> [AFProduct] {
        var prodArray = [AFProduct]();
        let productStacks = self.productStack.subviews.filter{$0 is ProductControl};
        for stack in productStacks as! [ProductControl] {
            let prodVars = stack.subviews.filter{$0 is VarControl};
            let product = AFProduct();
            for prodVar in prodVars as! [VarControl] {
                let key = prodVar.currentVar;
                if key == "+ Var" {
                    continue;
                }
                let varValue = prodVar.currentValue;
                if key == "weight" || key == "productCount" {
                    do {
                        guard let value = Int(varValue) else {
                            throw MyError.FoundNil("invalid numeric product value(s)");
                        }
                        product.setValue(value, forKey: key);
                    } catch {
                        print("invalid numeric product value(s)");
                    }
                } else if key == "step" {
                    do {
                        guard let value = Int(varValue) else {
                            throw MyError.FoundNil("invalid step value(s)");
                        }
                        product.step = AFEcomerceStep(rawValue: value)!;
                    } catch {
                        print("invalid step value(s)");
                    }
                } else if key == "productSales" {
                    do {
                        guard let value = Float(varValue) else {
                            throw MyError.FoundNil("invalid product sales value");
                        }
                        product.productSales = value;
                    } catch {
                        print("invalid product sales value");
                    }
                } else {
                    product.setValue(varValue, forKey: key);
                }
            }
            prodArray.append(product);
        }
        return prodArray;
    }
}
