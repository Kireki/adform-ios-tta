//
//  TrackingVarControls.swift
//  Adform iOS TTA
//
//  Created by Adform on 2017-11-08.
//  Copyright © 2017 Adform. All rights reserved.
//

import UIKit

private func generateVarNameList(prefix: String, count: Int) -> [String] {
    var varNameArray = [String]();
    for i in 0..<count {
        varNameArray.append("\(prefix)\(i+1)");
    }
    return varNameArray;
}

class VarControl: UIStackView, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    //MARK: Properties
    var parentController: UIViewController? = nil;
    var type: String? = nil;
    var currentVar: String = "+ Var";
    var currentValue: String = "";
    private var varPicker: UIPickerView {
        get {
            let pickerFrame: CGRect = CGRect();
            let picker: UIPickerView = UIPickerView(frame: pickerFrame);
            picker.delegate = self;
            picker.dataSource = self;
            return picker;
        }
    }
    private var orderVarNameOptions: [String] {
        get {
            var orderVarList = [
                "orderId",
                "sale",
                "currency",
                "orderStatus",
                "country",
                "gender",
                "ageGroup",
                "basketSize"
            ];
            orderVarList.append(contentsOf: generateVarNameList(prefix: "sv", count: 255));
            orderVarList.append(contentsOf: generateVarNameList(prefix: "svn", count: 255));
            return orderVarList;
        }
    }
    private var productVarNameOptions: [String] {
        let productVarList = [
            "categoryName",
            "categoryId",
            "productName",
            "productId",
            "weight",
            "step",
            "productSales",
            "productCount"
        ];
//        productVarList.append(contentsOf: generateVarNameList(prefix: "sv", count: 255));
//        productVarList.append(contentsOf: generateVarNameList(prefix: "svn", count: 255));
        return productVarList;
    }
    var varNameButton: UIButton {
        get {
            let button = UIButton(type: .system);
            button.setTitle("+ Var", for: .normal);
            button.contentHorizontalAlignment = .center;
            button.widthAnchor.constraint(equalToConstant: 90).isActive = true;
            button.addTarget(self, action: #selector(self.showPickerPopup(button:)), for: .touchUpInside);
            return button;
        }
    };
    var varValueField: UITextField {
        get {
            let textField = UITextField();
            textField.placeholder = "Enter variable value";
            textField.borderStyle = .roundedRect;
            textField.delegate = self;
            return textField;
        }
    }
    var removeVarButton: UIButton {
        get {
            let removeButton = UIButton(type: .system);
            removeButton.setImage(#imageLiteral(resourceName: "Delete"), for: .normal);
            removeButton.contentHorizontalAlignment = .right;
            removeButton.tintColor = UIColor.red;
            removeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true;
            removeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true;
            removeButton.addTarget(self, action: #selector(VarControl.removeVarTapped(button:)), for: .touchUpInside);
            return removeButton;
        }
    }
    
    //MARK: Actions
    @objc func showPickerPopup(button: UIButton) {
        if self.parentController!.isEqual(nil) || self.type!.isEmpty {
            return;
        }
        let title = "Select a Variable";
        let message = "\n\n\n\n\n\n\n\n\n\n";
        let popup = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet);
        popup.isModalInPopover = true;
        let picker: UIPickerView = self.varPicker;
        popup.view.addSubview(picker);
        picker.translatesAutoresizingMaskIntoConstraints = false;
        let margins = popup.view.layoutMarginsGuide;
        picker.centerXAnchor.constraint(equalTo: popup.view.centerXAnchor).isActive = true;
        picker.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40).isActive = true;
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil);
        popup.addAction(cancelAction);
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if self.type == "order" {
                button.setTitle(self.orderVarNameOptions[picker.selectedRow(inComponent: 0)], for: .normal);
                self.currentVar = self.orderVarNameOptions[picker.selectedRow(inComponent: 0)];
            } else if self.type == "product" {
                button.setTitle(self.productVarNameOptions[picker.selectedRow(inComponent: 0)], for: .normal);
                self.currentVar = self.productVarNameOptions[picker.selectedRow(inComponent: 0)];
            } else {
                return;
            }
        });
        popup.addAction(okAction);
        self.parentController?.present(popup, animated: true, completion: nil);
    }
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    required init(coder: NSCoder) {
        super.init(coder: coder);
    }
    init(parentController: UIViewController, type: String) {
        self.init();
        self.parentController = parentController;
        self.type = type;
        setupControl();
    }
    
    //MARK: PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.type == "order" {
            return orderVarNameOptions.count;
        } else if self.type == "product" {
            return productVarNameOptions.count;
        } else {
            return 0;
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.type == "order" {
            return orderVarNameOptions[row];
        } else if self.type == "product" {
            return productVarNameOptions[row];
        } else {
            return "";
        }
    }
    //MARK: Textfield
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        self.currentValue = textField.text!;
//        return true;
//    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.currentValue = textField.text!;
    }
    
    private func setupControl() {
        self.axis = .horizontal;
        self.distribution = .fill;
        self.alignment = .fill;
        self.spacing = 5;
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.addArrangedSubview(self.varNameButton);
        self.addArrangedSubview(self.varValueField);
        self.addArrangedSubview(self.removeVarButton);
    }
    
    @objc func removeVarTapped(button: UIButton) {
        button.superview?.removeFromSuperview()
    }
}
