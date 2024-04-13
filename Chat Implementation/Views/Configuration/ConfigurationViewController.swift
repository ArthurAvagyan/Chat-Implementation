//
//  ConfigurationViewController.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import UIKit

final class ConfigurationViewController: Controller<ConfigurationViewModel, ConfigurationView> {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Configuration"
	}

	override func setupBindings() {
		contentView.onBackgroundColorButtonAction
			.receive(on: DispatchQueue.main)
			.sink { [unowned self] selectedColor in
				let picker = UIColorPickerViewController()
				picker.selectedColor = selectedColor
				picker.delegate = self
				present(picker, animated: true)
			}
			.store(in: &cancellables)
		
		contentView.onProceedButtonAction
			.receive(on: DispatchQueue.main)
			.sink { [unowned self] _ in
				let viewModel = ChatViewModel(configuration: viewModel.configuration)
				let viewController = ChatViewController(viewModel: viewModel)
				navigationController?.pushViewController(viewController, animated: true)
			}
			.store(in: &cancellables)
	}
}

extension ConfigurationViewController: UIColorPickerViewControllerDelegate {
	
	func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
		viewModel.backgroundColor = color
	}
}
