//
//  ReceivedTextCell.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 14.04.24.
//

import UIKit
import Combine

final class ReceivedTextCell: UICollectionViewCell {
	
	private var cancellable: AnyCancellable?
	
	var bubble: UIView!
	var senderImage: UIImageView!
	var senderNameLabel: UILabel!
	var messageLabel: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		bubble = UIView()
		bubble.layer.masksToBounds = true
		addSubview(bubble)
		
		senderImage = UIImageView()
		senderImage.layer.cornerRadius = 16
		senderImage.layer.masksToBounds = true
		senderImage.image = .avatar
		addSubview(senderImage)
		
		senderNameLabel = UILabel()
		bubble.addSubview(senderNameLabel)
		
		messageLabel = UILabel()
		messageLabel.numberOfLines = 0
		messageLabel.lineBreakMode = .byWordWrapping
		bubble.addSubview(messageLabel)
		
		senderImage.translatesAutoresizingMaskIntoConstraints = false
		senderNameLabel.translatesAutoresizingMaskIntoConstraints = false
		bubble.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			senderImage.leadingAnchor.constraint(equalTo: leadingAnchor),
			senderImage.topAnchor.constraint(equalTo: topAnchor),
			senderImage.heightAnchor.constraint(equalToConstant: 32),
			senderImage.widthAnchor.constraint(equalToConstant: 32),
			
			bubble.leadingAnchor.constraint(equalTo: senderImage.trailingAnchor, constant: 8),
			bubble.topAnchor.constraint(equalTo: topAnchor),
			bubble.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
			bubble.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			senderNameLabel.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 12),
			senderNameLabel.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 8),
			senderNameLabel.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -8),
			
			messageLabel.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 12),
			messageLabel.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: 8),
			messageLabel.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -8),
			messageLabel.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -12),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		cancellable?.cancel()
		cancellable = nil
	}
	
	func update(with textMessage: ChatReceivedTextMessage, configuration: ConfigurationModel) {
		messageLabel.text = textMessage.messaage
		messageLabel.numberOfLines = 0
		messageLabel.font = .systemFont(ofSize: configuration.textSize)
		senderNameLabel.text = textMessage.sender.name
		senderNameLabel.font = .systemFont(ofSize: configuration.textSize - 2)
		
		cancellable = URLSession.shared.dataTaskPublisher(for: textMessage.sender.imageUrl)
			.map { UIImage(data: $0.data) }
			.replaceError(with: nil)
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { [weak self] image in
				self?.senderImage.image = image
			})
		
		bubble.backgroundColor = configuration.backgroundColor.withAlphaComponent(0.4)
		bubble.layer.cornerRadius = configuration.cornerRadius
	}
}
