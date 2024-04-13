//
//  ChatMessageView.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import UIKit

protocol ChatCellRepesentable: UIView {
	func update(with message: String, sent: Bool, configuration: ConfigurationModel)
}

class ChatMessageView: ChatBubbleView, ChatCellRepesentable {
	
	var messageLabel: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		messageLabel = UILabel()
		bubble.addSubview(messageLabel)
		
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			messageLabel.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 12),
			messageLabel.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 8),
			messageLabel.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: 8),
			messageLabel.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: 12),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func update(with message: String, sent: Bool, configuration: ConfigurationModel) {
		update(dateString: "dateString", sent: sent, configuration: configuration)
		
		messageLabel.text = message
		messageLabel.font = .systemFont(ofSize: configuration.textSize)
	}
}
