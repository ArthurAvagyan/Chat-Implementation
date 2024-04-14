//
//  InsetLabel.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import UIKit

class InsetLabel: UILabel {
	
	var insets: UIEdgeInsets = .zero {
		didSet {
			setNeedsDisplay()
		}
	}
	
	override func drawText(in rect: CGRect) {
		super.drawText(in: rect.inset(by: insets))
	}
	
	override var intrinsicContentSize: CGSize {
		let size = super.intrinsicContentSize
		return CGSize(width: size.width + insets.left + insets.right, height: size.height + insets.top + insets.bottom)
	}
}
