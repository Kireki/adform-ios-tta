//
//  ProductControl.swift
//  Adform iOS TTA
//
//  Created by Adform on 2017-11-09.
//  Copyright © 2017 Adform. All rights reserved.
//

import UIKit

class ProductControl: UIStackView {
    //MARK: Properties
    var parentController: UIViewController? = nil;
    var addVarButton: UIButton {
        get {
            let button = UIButton(type: .system);
            button.setTitle("+ Add Product Variable", for: .normal);
            button.contentHorizontalAlignment = .left;
            button.addTarget(self, action: #selector(ProductControl.addVarTapped(button:)), for: .touchUpInside);
            return button;
        }
    }
    var removeProductButton: UIButton {
        get {
            let button = UIButton(type: .system);
            button.setTitle("Remove Product", for: .normal);
            button.contentHorizontalAlignment = .right;
            button.setTitleColor(UIColor.red, for: .normal);
            button.addTarget(self, action: #selector(ProductControl.removeProductTapped(button:)), for: .touchUpInside);
            return button;
        }
    }
    var buttonStack: UIStackView {
        get {
            let stack = UIStackView();
            stack.axis = .horizontal;
            stack.distribution = .fill;
            stack.alignment = .fill;
            stack.translatesAutoresizingMaskIntoConstraints = false;
            stack.addArrangedSubview(self.addVarButton);
            stack.addArrangedSubview(self.removeProductButton);
            return stack;
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    required init(coder: NSCoder) {
        super.init(coder: coder);
    }
    init(parentController: UIViewController) {
        self.init();
        self.parentController = parentController;
        setupProductControl();
    }
    private func setupProductControl() {
        self.axis = .vertical;
        self.distribution = .equalSpacing
        self.alignment = .fill;
        self.spacing = 16;
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.addArrangedSubview(self.buttonStack);
    }
    
    @objc func addVarTapped(button: UIButton) {
        self.addArrangedSubview(VarControl(parentController: self.parentController!, type: "product"));
    }
    
    @objc func removeProductTapped(button: UIButton) {
        button.superview?.superview?.removeFromSuperview();
    }
}
