//
//  ReceivedImageCell.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 14.04.24.
//

import UIKit
import Combine

final class ReceivedImageCell: UICollectionViewCell {
	
	private var cancellables = Set<AnyCancellable>()
	
	var bubble: UIView!
	var senderImage: UIImageView!
	var senderNameLabel: UILabel!
	var imageView: UIImageView!
	
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
		senderNameLabel.setContentHuggingPriority(.required, for: .vertical)
		bubble.addSubview(senderNameLabel)
		
		imageView = UIImageView()
		imageView.layer.masksToBounds = true
		bubble.addSubview(imageView)
		
		senderImage.translatesAutoresizingMaskIntoConstraints = false
		senderNameLabel.translatesAutoresizingMaskIntoConstraints = false
		bubble.translatesAutoresizingMaskIntoConstraints = false
		imageView.translatesAutoresizingMaskIntoConstraints = false
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
			
			imageView.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 1),
			imageView.topAnchor.constraint(equalTo: senderNameLabel.bottomAnchor, constant: 8),
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
		
		cancellables.forEach { $0.cancel() }
		cancellables.removeAll()
	}
	
	func update(with imageMessage: ChatReceivedImageMessage, configuration: ConfigurationModel) {
		layer.transform = CATransform3DMakeScale(1, -1, 1)
		senderNameLabel.text = imageMessage.sender.name
		senderNameLabel.font = .systemFont(ofSize: configuration.textSize - 2)
		
		URLSession.shared.dataTaskPublisher(for: imageMessage.sender.imageUrl)
			.map { UIImage(data: $0.data) }
			.replaceError(with: nil)
			.receive(on: DispatchQueue.main)
			.sink(receiveValue: { [weak self] image in
				self?.senderImage.image = image
			})
			.store(in: &cancellables)
				
		if let cachedImage = ImageCache.shared.getImage(forKey: "\(imageMessage.image.imageUrl.path))_resized") {
			imageView.image = cachedImage.resizeImage(targetSize: imageView.frame.size)
		} else {
			URLSession.shared.dataTaskPublisher(for: imageMessage.image.imageUrl)
				.map { UIImage(data: $0.data) }
				.replaceError(with: nil)
				.receive(on: DispatchQueue.main)
				.sink(receiveValue: { [weak self] image in
					guard let self else { return }
					let resizedImage = image?.resizeImage(targetSize: imageView.frame.size)
					if let image,
					   let resizedImage {
						ImageCache.shared.setImage(image, forKey: imageMessage.image.imageUrl.path)
						ImageCache.shared.setImage(resizedImage, forKey: "\(imageMessage.image.imageUrl.path))_resized")
					}
					
					imageView.image = resizedImage
				})
				.store(in: &cancellables)
		}
		
		imageView.roundCorners(topLeft: 4, topRight: 4, bottomLeft: max(0, configuration.cornerRadius - 1), bottomRight: max(0, configuration.cornerRadius - 1))
		let ratio = CGFloat(imageMessage.image.height) / CGFloat(imageMessage.image.width)
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
			imageView.image = UIImage(data: imageMessage.image.thumbImageData)
		}
		
		bubble.backgroundColor = configuration.backgroundColor.withAlphaComponent(0.4)
		bubble.layer.cornerRadius = configuration.cornerRadius
	}
	
}
