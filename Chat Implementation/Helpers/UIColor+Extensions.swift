//
//  UIColor+Extensions.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import UIKit.UIColor

extension UIColor {
	
	var inverted: UIColor {
		var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
		self.getRed(&r, green: &g, blue: &b, alpha: &a)
		return UIColor(red: (1 - r), green: (1 - g), blue: (1 - b), alpha: a)
	}
}
