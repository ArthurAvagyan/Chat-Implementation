//
//  ChatViewModel.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import Foundation

final class ChatViewModel: ViewModel {
	
	let configuration: ConfigurationModel
	
	init(configuration: ConfigurationModel) {
		self.configuration = configuration
	}
}
