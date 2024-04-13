//
//  SentMessageCell.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import UIKit

final class SentMessageCell: UICollectionViewCell {
	
	var containerView: ChatCellRepesentable!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		containerView = ChatMessageView(frame: frame)
		contentView.addSubview(containerView)
		
		containerView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
			containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 12),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func update(with message: String, sent: Bool, configuration: ConfigurationModel) {
		containerView.update(with: message, sent: sent, configuration: configuration)
	}
}
