//
//  ChatRepresentables.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 15.04.24.
//

import Foundation

struct Message {
	let id: Int
	let message: String?
	let image: Photo?
	let sender: Sender?
}

struct Sender {
	let name: String
	let imageUrl: URL
}

struct Photo {
	let imageUrl: URL
	let width: Int
	let height: Int
	let thumbImageData: Data
	
	init?(imageUrl: URL?, width: Int, height: Int, thumbImageData: Data) {
		guard let imageUrl else {
			return nil
		}
		self.imageUrl = imageUrl
		self.width = width
		self.height = height
		self.thumbImageData = thumbImageData
	}
}



protocol ChatRepresentable {
	var id: Int { get }
}
protocol ChatImageRepresentable {
	var image: Photo { get }
}

protocol ChatTextRepresentable {
	var messaage: String { get }
}

protocol ChatSenderRepresentable {
	var sender: Sender { get }
}



struct ChatSentTextMessage: ChatRepresentable,ChatTextRepresentable {
	let id: Int
	let messaage: String
}

struct ChatSentImageMessage: ChatRepresentable, ChatImageRepresentable {
	let id: Int
	let image: Photo
}

struct ChatSentImageTextMessage: ChatRepresentable, ChatImageRepresentable, ChatTextRepresentable {
	let id: Int
	let messaage: String
	let image: Photo
}

struct ChatReceivedTextMessage: ChatRepresentable, ChatTextRepresentable {
	let id: Int
	let messaage: String
	let sender: Sender
}

struct ChatReceivedImageMessage: ChatRepresentable, ChatImageRepresentable {
	let id: Int
	let image: Photo
	let sender: Sender
}

struct ChatReceivedImageTextMessage: ChatRepresentable, ChatImageRepresentable, ChatTextRepresentable {
	let id: Int
	let messaage: String
	let image: Photo
	let sender: Sender
}
