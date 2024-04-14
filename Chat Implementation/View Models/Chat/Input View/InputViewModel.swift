//
//  InputViewModel.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import Foundation
import Combine
import UIKit

final class InputViewModel: ViewModel {

	let configuration: ConfigurationModel
	@Published var message = ""
	private(set) var onAttachmentButtonAction = PassthroughSubject<Void, Never>()
	
	init(configuration: ConfigurationModel) {
		self.configuration = configuration
	}
	
	func attachmentButtonAction() {
		onAttachmentButtonAction.send()
	}
	
	func sendButtonAction() {
		message = ""
	}
}
