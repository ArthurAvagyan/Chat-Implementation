//
//  MessageItem.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import Foundation

struct MessageItem: Codable {
	
	let id: Int
	let chatId: Int
	let senderId: Int
	let body: String
	let type: String
	let createdAt: Date
	let incoming: Bool
	let status: MessageStatus
}
