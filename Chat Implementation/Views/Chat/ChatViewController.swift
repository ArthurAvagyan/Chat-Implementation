//
//  ChatViewController.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import UIKit

final class ChatViewController: Controller<ChatViewModel, ChatView>, UINavigationControllerDelegate {
	
	func showImagePicker() {
		let imagePicker = UIImagePickerController()
		
		imagePicker.delegate = self
		imagePicker.sourceType = .savedPhotosAlbum
		imagePicker.allowsEditing = false
		
		present(imagePicker, animated: true, completion: nil)
	}
}

extension ChatViewController: UIImagePickerControllerDelegate {
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true)
		
		guard let image = info[.originalImage] as? UIImage else { return }
		
		viewModel.image = image
	}
}
