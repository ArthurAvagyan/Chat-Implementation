//
//  Constants.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import UIKit

struct Constants {
	
	struct Size {
		static var cornerRadius: CGFloat = 8
		static var paddingHorizontal: CGFloat = 16
		static var paddingVertical: CGFloat = 32
		static var buttonDimention: CGFloat = 52
		static var textInputHeight: CGFloat = 36
		static let dateLabelBottomSpacing: CGFloat = 8
	}
	
	struct ChatConfiguration {
		
		static let `default` = ChatConfiguration(backgroundColor: .white, cornerRadius: Size.cornerRadius, textSize: UIFont.systemFontSize)
		
		var backgroundColor: UIColor
		var cornerRadius: CGFloat
		var textSize: CGFloat
	}
}

