//
//  UIView+Extensions.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 14.04.24.
//

import UIKit

extension UIView{
	func roundCorners(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
		let topLeftRadius = CGSize(width: topLeft, height: topLeft)
		let topRightRadius = CGSize(width: topRight, height: topRight)
		let bottomLeftRadius = CGSize(width: bottomLeft, height: bottomLeft)
		let bottomRightRadius = CGSize(width: bottomRight, height: bottomRight)
		let maskPath = UIBezierPath(shouldRoundRect: bounds, topLeftRadius: topLeftRadius, topRightRadius: topRightRadius, bottomLeftRadius: bottomLeftRadius, bottomRightRadius: bottomRightRadius)
		let shape = CAShapeLayer()
		shape.path = maskPath.cgPath
		layer.mask = shape
	}
}
