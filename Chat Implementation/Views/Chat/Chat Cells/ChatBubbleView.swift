//
//  ChatBubbleView.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import UIKit

class ChatBubbleView: UIView {
	
//	var containerView: UIView!
	var bubble: UIView!
	var dateLabel: InsetLabel!
//	private var leadingConstraint: NSLayoutConstraint!
//	private var trailingConstraint: NSLayoutConstraint!
	private var dateLabelTrailingConstraint: NSLayoutConstraint!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
//		containerView = UIView()
//		containerView.backgroundColor = .clear
//		addSubview(containerView)
		
		bubble = UIView()
		addSubview(bubble)
//		containerView.addSubview(bubble)

		
		dateLabel = InsetLabel()
		dateLabel.textColor = .lightText
		dateLabel.backgroundColor = UIColor(resource: .dateBackground)
		dateLabel.insets = .init(top: 2, left: 4, bottom: 2, right: 4)
		dateLabel.layer.cornerCurve = .continuous
		dateLabel.clipsToBounds = true
		bubble.addSubview(dateLabel)
		
//		containerView.translatesAutoresizingMaskIntoConstraints = false
		bubble.translatesAutoresizingMaskIntoConstraints = false
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		
//		leadingConstraint = NSLayoutConstraint(item: bubble!, attribute: .leading, relatedBy: .equal, toItem: containerView, attribute: .leading, multiplier: 1, constant: 0)
//		trailingConstraint = NSLayoutConstraint(item: bubble!, attribute: .trailing, relatedBy: .equal, toItem: containerView, attribute: .trailing, multiplier: 1, constant: 0)
		dateLabelTrailingConstraint = NSLayoutConstraint(item: dateLabel!, attribute: .trailing, relatedBy: .equal, toItem: bubble, attribute: .trailing, multiplier: 1, constant: 0)
		NSLayoutConstraint.activate([
//			containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
//			containerView.topAnchor.constraint(equalTo: topAnchor),
//			containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
//			containerView.bottomAnchor.constraint(equalTo: bottomAnchor),

			bubble.leadingAnchor.constraint(equalTo: leadingAnchor),
			bubble.topAnchor.constraint(equalTo: topAnchor),
			bubble.trailingAnchor.constraint(equalTo: trailingAnchor),
			bubble.bottomAnchor.constraint(equalTo: bottomAnchor),
			
//			leadingConstraint,
//			bubble.topAnchor.constraint(equalTo: containerView.topAnchor),
//			trailingConstraint,
//			bubble.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
			
			dateLabel.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: Constants.Size.dateLabelBottomSpacing),
			dateLabelTrailingConstraint
		])
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func update(dateString: String, sent: Bool, configuration: ConfigurationModel) {
		dateLabel.font = .systemFont(ofSize: configuration.textSize - 6) // -6 is the difference of text sizes given in design
		dateLabel.layer.cornerRadius = dateLabel.frame.height / 2
		dateLabel.text = dateString
		
		bubble.backgroundColor = configuration.backgroundColor.withAlphaComponent(0.4)
		
//		configureHorizontalConstraints(sent: sent)
	}
	
//	private func configureHorizontalConstraints(sent: Bool) {
//		leadingConstraint.constant = sent ? 0 : 60
//		trailingConstraint.constant = sent ? 60 : 0
//		NSLayoutConstraint.changeRelation(of: &leadingConstraint, to: sent ? .equal : .greaterThanOrEqual)
//		NSLayoutConstraint.changeRelation(of: &trailingConstraint, to: sent ? .greaterThanOrEqual : .equal)
//	}
}
