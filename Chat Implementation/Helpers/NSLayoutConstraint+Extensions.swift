//
//  NSLayoutConstraint+Extensions.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import UIKit

extension NSLayoutConstraint {
		
	static func changeRelation(of constraint: inout NSLayoutConstraint, to relation: NSLayoutConstraint.Relation) {
		NSLayoutConstraint.deactivate([constraint])
		
		let newConstraint = NSLayoutConstraint(item: constraint.firstItem as Any,
											   attribute: constraint.firstAttribute,
											   relatedBy: relation,
											   toItem: constraint.secondItem,
											   attribute: constraint.secondAttribute,
											   multiplier: constraint.multiplier,
											   constant: constraint.constant)
		
		newConstraint.priority = constraint.priority
		newConstraint.shouldBeArchived = constraint.shouldBeArchived
		newConstraint.identifier = constraint.identifier
		
		NSLayoutConstraint.activate([newConstraint])
		constraint = newConstraint
	}
}
