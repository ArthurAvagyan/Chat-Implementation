//
//  SentImageTextCell.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 14.04.24.
//

import UIKit
import Combine

final class SentImageTextCell: UICollectionViewCell {
	
	private var cancellable: AnyCancellable?
	
	var bubble: UIView!
	var messageLabel: UILabel!
	var imageView: UIImageView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		bubble = UIView()
		bubble.layer.masksToBounds = true
		addSubview(bubble)
		
		messageLabel = UILabel()
		messageLabel.numberOfLines = 0
		messageLabel.lineBreakMode = .byWordWrapping
		bubble.addSubview(messageLabel)
		
		imageView = UIImageView()
		imageView.layer.masksToBounds = true
		bubble.addSubview(imageView)
		
		bubble.translatesAutoresizingMaskIntoConstraints = false
		imageView.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			bubble.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 32),
			bubble.topAnchor.constraint(equalTo: topAnchor),
			bubble.trailingAnchor.constraint(equalTo: trailingAnchor),
			bubble.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			messageLabel.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 12),
			messageLabel.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 8),
			messageLabel.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -8),
			
			imageView.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 1),
			imageView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8),
			imageView.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -1),
			imageView.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -1),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		imageView.image = nil
		
		cancellable?.cancel()
		cancellable = nil
	}
	
	func update(with textImageMessage: ChatSentImageTextMessage, configuration: ConfigurationModel) {
		messageLabel.text = textImageMessage.messaage
		messageLabel.font = .systemFont(ofSize: configuration.textSize)
				
		bubble.backgroundColor = configuration.backgroundColor.withAlphaComponent(0.4)
		bubble.layer.cornerRadius = configuration.cornerRadius
				
		if let cachedImage = ImageCache.shared.getImage(forKey: "\(textImageMessage.image.imageUrl.path))_resized") {
			imageView.image = cachedImage.resizeImage(targetSize: imageView.frame.size)
		} else {
			cancellable = URLSession.shared.dataTaskPublisher(for: textImageMessage.image.imageUrl)
				.map { UIImage(data: $0.data) }
				.replaceError(with: nil)
				.receive(on: DispatchQueue.main)
				.sink(receiveValue: { [weak self] image in
					guard let self else { return }
					let resizedImage = image?.resizeImage(targetSize: imageView.frame.size)
					if let image,
					   let resizedImage {
						ImageCache.shared.setImage(image, forKey: textImageMessage.image.imageUrl.path)
						ImageCache.shared.setImage(resizedImage, forKey: "\(textImageMessage.image.imageUrl.path))_resized")
					}
					
					imageView.image = resizedImage
				})
		}
		
		imageView.roundCorners(topLeft: 4, topRight: 4, bottomLeft: max(0, configuration.cornerRadius - 1), bottomRight: max(0, configuration.cornerRadius - 1))
		let ratio = CGFloat(textImageMessage.image.height) / CGFloat(textImageMessage.image.width)
		let aspect = NSLayoutConstraint(item: imageView!,
										attribute: .height,
										relatedBy: .equal,
										toItem: imageView!,
										attribute: .width,
										multiplier: ratio,
										constant: 0)
		aspect.priority = .defaultLow
		imageView.addConstraint(aspect)
		
		if imageView.image == nil {
			imageView.image = UIImage(data: textImageMessage.image.thumbImageData)
		}
	}
}
