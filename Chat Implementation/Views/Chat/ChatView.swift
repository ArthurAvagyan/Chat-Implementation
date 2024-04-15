//
//  ChatView.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import UIKit

final class ChatView: View<ChatViewModel> {
	
	var collectionView: UICollectionView!
	private var textInput: InputView!
	private var textInputBottomConstraint: NSLayoutConstraint!
	
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	func setupViews() {
		let flowLayout = UICollectionViewFlowLayout()
	
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.layer.transform = CATransform3DMakeScale(1, -1, 1)

		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(SentTextCell.self, forCellWithReuseIdentifier: .init(describing: SentTextCell.self))
		collectionView.register(SentImageCell.self, forCellWithReuseIdentifier: .init(describing: SentImageCell.self))
		collectionView.register(SentImageTextCell.self, forCellWithReuseIdentifier: .init(describing: SentImageTextCell.self))
		collectionView.register(ReceivedTextCell.self, forCellWithReuseIdentifier: .init(describing: ReceivedTextCell.self))
		collectionView.register(ReceivedImageCell.self, forCellWithReuseIdentifier: .init(describing: ReceivedImageCell.self))
		collectionView.register(ReceivedImageTextCell.self, forCellWithReuseIdentifier: .init(describing: ReceivedImageTextCell.self))
				
		let layout = ChatLayout()
		layout.delegate = self
		collectionView.collectionViewLayout = layout

		NotificationCenter.default.removeObserver(self)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(adjustForKeyboard),
											   name: UIResponder.keyboardWillShowNotification,
											   object: nil)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(adjustForKeyboard),
											   name: UIResponder.keyboardDidShowNotification,
											   object: nil)
		NotificationCenter.default.addObserver(self,
											   selector: #selector(adjustForKeyboard),
											   name: UIResponder.keyboardWillHideNotification,
											   object: nil)
		
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		collectionView.addGestureRecognizer(tapGesture)
		addSubview(collectionView)
		
		textInput = InputView(viewModel: viewModel.textImputViewModel)
		addSubview(textInput)
	}
	
	func setupConstraints() {
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		textInput.translatesAutoresizingMaskIntoConstraints = false
		textInputBottomConstraint = safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: textInput.bottomAnchor)
		NSLayoutConstraint.activate([
			collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: textInput.topAnchor),
			
			textInput.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			textInput.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			textInputBottomConstraint
		])
	}
	
	func setupBindings() {
		viewModel.onSelectImage
			.sink { [unowned self] image in
				viewModel.image = image
			}
			.store(in: &cancellables)
			
		viewModel.$chatMessages
			.receive(on: DispatchQueue.main)
			.sink { [weak self] chatMessages in
				self?.collectionView.reloadData()
			}
			.store(in: &cancellables)

		
	}
	
	@objc func adjustForKeyboard(notification: Notification) {
		guard let keyboardScreenEndFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
		if notification.name == UIResponder.keyboardWillHideNotification {
			textInputBottomConstraint.constant = 0
		} else if notification.name == UIResponder.keyboardWillShowNotification {
			textInputBottomConstraint.constant = keyboardScreenEndFrame.height - safeAreaInsets.bottom
		}
		
		UIView.animate(withDuration: 0.3) {
			self.superview?.layoutIfNeeded()
		}
	}

	
	@objc func dismissKeyboard() {
		endEditing(true)
	}
}

extension ChatView: ChatLayoutDelegate {
	
	func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
		var senderNameHeight: CGFloat = 0
		if let senderName = (viewModel.chatMessages[indexPath.item] as? ChatSenderRepresentable)?.sender.name {
			senderNameHeight += 8 // sender name top padding
			senderNameHeight += requiredHeight(text: senderName, cellWidth: cellWidth)
		}
		
		var textMessageHeight: CGFloat = 0
		if let message = (viewModel.chatMessages[indexPath.item] as? ChatTextRepresentable)?.messaage {
			textMessageHeight += 8 // message top padding
			textMessageHeight += requiredHeight(text: message, cellWidth: cellWidth)
		}
		
		var imgHeight: CGFloat = 0
		if ((viewModel.chatMessages[indexPath.item] as? ChatImageRepresentable)?.image) != nil {
			imgHeight += 200 // image fixed height
			imgHeight += 1 // image bottom padding
			
			imgHeight += senderNameHeight == 0 ? (textMessageHeight == 0 ? 1 : 8) : 8
		}
		
		if imgHeight == 0 {
			textMessageHeight += imgHeight == 0 ? 12 : 8 // message bottom padding 
		}
		
		return (imgHeight + textMessageHeight + senderNameHeight + 8)
	}
	
	func requiredHeight(text:String , cellWidth : CGFloat) -> CGFloat {
		let font = UIFont.systemFont(ofSize: viewModel.configuration.textSize)
		let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: cellWidth, height: .greatestFiniteMagnitude))
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		label.font = font
		label.text = text
		label.sizeToFit()
		return label.frame.height
	}
}

extension ChatView: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel.chatMessages.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let message = viewModel.chatMessages[indexPath.item]
		
		switch message {
		case let textMessage as ChatReceivedTextMessage:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .init(describing: ReceivedTextCell.self), for: indexPath) as! ReceivedTextCell
			cell.update(with: textMessage, configuration: viewModel.configuration)
			return cell
		case let imageMessage as ChatReceivedImageMessage:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .init(describing: ReceivedImageCell.self), for: indexPath) as! ReceivedImageCell
			cell.update(with: imageMessage, configuration: viewModel.configuration)
			return cell
		case let imageTextMessage as ChatReceivedImageTextMessage:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .init(describing: ReceivedImageTextCell.self), for: indexPath) as! ReceivedImageTextCell
			cell.update(with: imageTextMessage, configuration: viewModel.configuration)
			return cell
		case let textMessage as ChatSentTextMessage:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .init(describing: SentTextCell.self), for: indexPath) as! SentTextCell
			cell.update(with: textMessage, configuration: viewModel.configuration)
			return cell
		case let imageMessage as ChatSentImageMessage:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .init(describing: SentImageCell.self), for: indexPath) as! SentImageCell
			cell.update(with: imageMessage, configuration: viewModel.configuration)
			return cell
		case let imageTextMessage as ChatSentImageTextMessage:
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .init(describing: SentImageTextCell.self), for: indexPath) as! SentImageTextCell
			cell.update(with: imageTextMessage, configuration: viewModel.configuration)
			return cell
		default:
			fatalError("Unknown type, implement Message type")
		}
	}
}

extension ChatView: UICollectionViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height {
			viewModel.loadMore()
		}
	}
}
