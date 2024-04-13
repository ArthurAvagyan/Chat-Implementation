//
//  ConfigurationViewModel.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import Foundation
import UIKit.UIColor

final class ConfigurationViewModel: ViewModel {
	
	@Published var backgroundColor: UIColor
	@Published var cornerRadius: CGFloat
	@Published var textSize: CGFloat
	
	init(configuration: Constants.ChatConfiguration = .default) {
		self.backgroundColor = configuration.backgroundColor
		self.cornerRadius = configuration.cornerRadius
		self.textSize = configuration.textSize
	}
}
