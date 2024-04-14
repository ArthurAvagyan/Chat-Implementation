//
//  SentTextCell.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 14.04.24.
//

import UIKit

final class SentTextCell: UICollectionViewCell {
	
	var bubble: UIView!
	var messageLabel: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		bubble = UIView()
		bubble.layer.masksToBounds = true
		addSubview(bubble)
		
		messageLabel = UILabel()
		messageLabel.numberOfLines = 0
		messageLabel.lineBreakMode = .byWordWrapping
		bubble.addSubview(messageLabel)
		
		bubble.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			bubble.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 32),
			bubble.topAnchor.constraint(equalTo: topAnchor),
			bubble.trailingAnchor.constraint(equalTo: trailingAnchor),
			bubble.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			messageLabel.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 12),
			messageLabel.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 8),
			messageLabel.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -8),
			messageLabel.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -12),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func update(with textMessage: ChatSentTextMessage, configuration: ConfigurationModel) {
		messageLabel.text = textMessage.messaage
		messageLabel.font = .systemFont(ofSize: configuration.textSize)
		
		bubble.backgroundColor = configuration.backgroundColor.withAlphaComponent(0.4)
		bubble.layer.cornerRadius = configuration.cornerRadius
	}
	
	
}
