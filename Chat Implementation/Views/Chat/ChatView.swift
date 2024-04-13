//
//  ChatView.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import UIKit

final class ChatView: View<ChatViewModel> {
	
	private var collectionView: UICollectionView!
	private var textInput: InputView!
	
	func setupViews() {
		let flowLayout = UICollectionViewFlowLayout()
	
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(SentMessageCell.self, forCellWithReuseIdentifier: .init(describing: SentMessageCell.self))
		
//		let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//		layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
//		layout.minimumInteritemSpacing = 5.0
//		layout.minimumLineSpacing = 5.0
//		layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 40)/3, height: ((UIScreen.main.bounds.size.width - 40)/3))
//		layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//		collectionView.collectionViewLayout = layout
		
		addSubview(collectionView)
		
		let viewModel = InputViewModel(configuration: viewModel.configuration)
		textInput = InputView(viewModel: viewModel)
		addSubview(textInput)
	}
	
	func setupConstraints() {
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		textInput.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
			collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: textInput.topAnchor),
			
			textInput.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
			textInput.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
			textInput.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
		])
	}
	
	func setupBindings() {
		
	}
	
	
}

extension ChatView: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		10
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: .init(describing: SentMessageCell.self), for: indexPath) as! SentMessageCell
		cell.update(with: "Hello", sent: .random(), configuration: viewModel.configuration)
		return cell
	}
}

extension ChatView: UICollectionViewDelegate {
	
}

extension ChatView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		CGSize(width: 200, height: 200)
	}
	
}
