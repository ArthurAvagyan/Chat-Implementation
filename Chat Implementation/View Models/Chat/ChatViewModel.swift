//
//  ChatViewModel.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import Foundation
import Combine
import UIKit

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


final class ChatViewModel: ViewModel {
	var cancellables = Set<AnyCancellable>()

	let configuration: ConfigurationModel
	
	@Published var chatMessages: [ChatRepresentable] = []

	private var canLoadMore = true
	
	private(set) var onSelectImage = PassthroughSubject<UIImage, Never>()
	private(set) var onAttachmentButtonAction = PassthroughSubject<Void, Never>()
	@Published var image: UIImage? = nil
	@Published var message: String = ""

	let textImputViewModel: InputViewModel
	
	init(configuration: ConfigurationModel) {
		self.configuration = configuration
		textImputViewModel = InputViewModel(configuration: configuration)
		textImputViewModel.onAttachmentButtonAction
			.sink(receiveValue: { [unowned self] _ in
				onAttachmentButtonAction.send()
			})
			.store(in: &cancellables)
		
		let chatMessages = generateMessageSamples(30)
		let chatRepresentableMessages = convertToChatRepresentable(chatMessages)
		self.chatMessages = chatRepresentableMessages
	}
	
	func loadMore() {
		guard canLoadMore else { return }
		canLoadMore = false
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
			guard let self else { return }
			let chatMessages = generateMessageSamples(configuration.loadMoreCount)
			let chatRepresentableMessages = convertToChatRepresentable(chatMessages)
			self.chatMessages.append(contentsOf: chatRepresentableMessages)
			canLoadMore = true
		}
	}
	
	private func convertToChatRepresentable(_ chatMessages: [Message]) -> [ChatRepresentable]{
		let chatRepresentableMessages: [ChatRepresentable] = chatMessages.map { chatMessage in
			if let sender = chatMessage.sender {
				if let message = chatMessage.message,
				   let image = chatMessage.image {
					ChatReceivedImageTextMessage(id: chatMessage.id,
												 messaage: message,
												 image: image,
												 sender: sender)
				} else if let message = chatMessage.message {
					ChatReceivedTextMessage(id: chatMessage.id,
											messaage: message,
											sender: sender)
				} else if let image = chatMessage.image {
					ChatReceivedImageMessage(id: chatMessage.id,
											 image: image,
											 sender: sender)
				} else {
					nil
				}
			} else {
				if let message = chatMessage.message,
				   let image = chatMessage.image {
					ChatSentImageTextMessage(id: chatMessage.id,
											 messaage: message,
											 image: image)
				} else if let message = chatMessage.message {
					ChatSentTextMessage(id: chatMessage.id,
										messaage: message)
				} else if let image = chatMessage.image {
					ChatSentImageMessage(id: chatMessage.id,
										 image: image)
				} else {
					nil
				}
			}
		}.compactMap { $0 }
		
		return chatRepresentableMessages
	}
	
	private func generateMessageSamples(_ count: Int) -> [Message] {
		var chatMessages: [Message] = []
		for i in 1...count {
			// Randomly choose if the message will contain text, image, or both
			let messageType = Int.random(in: 0...2)
			
			var sender: Sender? = nil
			
			// Randomly assign sender if the message is not sent by you
			if Bool.random() {
				sender = Sender(name: "John", imageUrl: URL(string: "https://picsum.photos/id/274/30/30")!)
			}
			
			var message: String? = nil
			var imageUrl: String = ""
			let width = 2000 + i
			let height = 3000 - i
			
			// Depending on messageType, generate text, image URL, or both
			switch messageType {
			case 0:
				message = "Text message \(i)"
			case 1:
				imageUrl = "https://picsum.photos/id/\(i)/\(width)/\(height)"
			case 2:
				message = "Text message with image \(i)"
				imageUrl = "https://picsum.photos/id/\(i)/\(width)/\(height)"
			default:
				break
			}
			
			// Create a ChatMessage instance
			let chatMessage = Message(id: i,
									  message: message,
									  image: Photo(imageUrl: URL(string: imageUrl),
												   width: width,
												   height: height,
												   // we assume thumb image is sent via socket
												   thumbImageData: Data(base64Encoded: "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")!),
									  sender: sender)
			chatMessages.append(chatMessage)
		}
		
		return chatMessages
	}
}
