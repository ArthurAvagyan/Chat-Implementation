//
//  InputView.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import UIKit

final class InputView: View<InputViewModel> {
	
	private var separatorView: UIView!
	private var attachmentButton: UIButton!
	private var textView: UITextView!
	private var sendButton: UIButton!
	
	init(viewModel: InputViewModel) {
		super.init(frame: .zero, viewModel: viewModel)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	required init(frame: CGRect, viewModel: InputViewModel) {
		super.init(frame: frame, viewModel: viewModel)
	}
	
	func setupViews() {
		separatorView = UIView()
		separatorView.backgroundColor = UIColor(resource: .grayBackground)
		addSubview(separatorView)
		
		attachmentButton = UIButton(configuration: .plain())
		attachmentButton.configuration?.image = UIImage(resource: .attach)
		attachmentButton.addAction(.init(handler: { [unowned self] _ in
			viewModel.attachmentButtonAction()
		}), for: .touchUpInside)
		addSubview(attachmentButton)
		
		textView = UITextView()
		textView.backgroundColor = UIColor(resource: .grayBackground)
		textView.layer.cornerRadius = Constants.Size.textInputHeight / 2
		textView.layer.cornerCurve = .continuous
		textView.layer.masksToBounds = true
		textView.text = "Write a message..."
		textView.textColor = UIColor(resource: .inputPlaceholder)
		textView.font = .systemFont(ofSize: viewModel.configuration.textSize)
		addSubview(textView)
		
		sendButton = UIButton(configuration: .plain())
		sendButton.configuration?.image = UIImage(resource: .send)
		sendButton.addAction(.init(handler: { [unowned self] _ in
			viewModel.sendButtonAction()
		}), for: .touchUpInside)
		addSubview(sendButton)
	}
	
	func setupConstraints() {
		separatorView.translatesAutoresizingMaskIntoConstraints = false
		attachmentButton.translatesAutoresizingMaskIntoConstraints = false
		textView.translatesAutoresizingMaskIntoConstraints = false
		sendButton.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			separatorView.heightAnchor.constraint(equalToConstant: 1),
			separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
			separatorView.topAnchor.constraint(equalTo: topAnchor),
			separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
			
			attachmentButton.heightAnchor.constraint(equalToConstant: Constants.Size.buttonDimention),
			attachmentButton.widthAnchor.constraint(equalToConstant: Constants.Size.buttonDimention),
			attachmentButton.leadingAnchor.constraint(equalTo: leadingAnchor),
			attachmentButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
			attachmentButton.bottomAnchor.constraint(equalTo: bottomAnchor),
			
			textView.heightAnchor.constraint(equalToConstant: Constants.Size.textInputHeight),
			textView.leadingAnchor.constraint(equalTo: attachmentButton.trailingAnchor),
			textView.topAnchor.constraint(greaterThanOrEqualTo: separatorView.bottomAnchor),
			textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor),
			textView.centerYAnchor.constraint(equalTo: centerYAnchor),
			
			sendButton.heightAnchor.constraint(equalToConstant: Constants.Size.buttonDimention),
			sendButton.widthAnchor.constraint(equalToConstant: Constants.Size.buttonDimention),
			sendButton.trailingAnchor.constraint(equalTo: trailingAnchor),
			sendButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
			sendButton.bottomAnchor.constraint(equalTo: bottomAnchor),
		])
	}
	
	func setupBindings() {
		
	}
}
