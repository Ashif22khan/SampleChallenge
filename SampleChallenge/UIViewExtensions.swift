//
//  UIViewExtensions.swift
//  SampleChallenge
//
//  Created by ashif khan on 19/09/18.
//  Copyright © 2018 ashif khan. All rights reserved.
//

import UIKit

extension UIView {
    func roundedRect(){
        self.layer.cornerRadius = 10
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
}
