//
//  CustomButton.swift
//  Adform iOS TTA
//
//  Created by Adform on 2017-11-07.
//  Copyright © 2017 Adform. All rights reserved.
//

import UIKit
@IBDesignable class CustomButton: UIButton {
    @IBInspectable var buttonBackground: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1) {
        didSet {
            self.backgroundColor = self.buttonBackground;
        }
    }
    
    @IBInspectable var highlightBackground: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
    
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? self.highlightBackground : self.buttonBackground;
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setupButton();
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder);
        setupButton();
    }
    
    private func setupButton() {
        self.backgroundColor = self.buttonBackground;
    }
}
