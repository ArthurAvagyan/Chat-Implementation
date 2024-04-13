//
//  ConfigurationView.swift
//  Chat Implementation
//
//  Created by Arthur Avagyan on 13.04.24.
//

import UIKit
import Combine

final class ConfigurationView: View<ConfigurationViewModel> {
	
	private(set) var onBackgroundColorButtonAction = PassthroughSubject<UIColor, Never>()
	private(set) var onProceedButtonAction = PassthroughSubject<Void, Never>()
	
	private var backgroundColorButton: UIButton!
	private var textSizeLabel: UILabel!
	private var textSizeStepper: UIStepper!
	private var cornerRadiusLabel: UILabel!
	private var cornerRadiusSlider: UISlider!
	private var proceedButton: UIButton!
	
	func setupViews() {
		backgroundColorButton = UIButton(configuration: .plain())
		backgroundColorButton.layer.cornerCurve = .continuous
		backgroundColorButton.tintColor = .black
		backgroundColorButton.addAction(UIAction(handler: { [unowned self] _ in
			onBackgroundColorButtonAction.send(viewModel.backgroundColor)
		}), for: .touchUpInside)
		backgroundColorButton.configuration?.title = "Set main color"
		addSubview(backgroundColorButton)
		
		textSizeLabel = UILabel()
		textSizeLabel.numberOfLines = 0
		addSubview(textSizeLabel)
		
		textSizeStepper = UIStepper()
		textSizeStepper.minimumValue = 8
		textSizeStepper.maximumValue = 32
		textSizeStepper.value = viewModel.textSize
		textSizeStepper.addTarget(self, action: #selector(cornerRadiusStepperValueChanged), for: .valueChanged)

		addSubview(textSizeStepper)

		cornerRadiusLabel = UILabel()
		addSubview(cornerRadiusLabel)
		
		cornerRadiusSlider = UISlider()
		cornerRadiusSlider.minimumValue = 0
		cornerRadiusSlider.maximumValue = 16
		cornerRadiusSlider.addTarget(self, action: #selector(cornerRadiusSliderValueChanged), for: .valueChanged)
		addSubview(cornerRadiusSlider)
		
		proceedButton = UIButton(configuration: .plain())
		proceedButton.layer.cornerCurve = .continuous
		proceedButton.tintColor = .black
		proceedButton.addAction(UIAction(handler: { [unowned self] _ in
			onProceedButtonAction.send()
		}), for: .touchUpInside)
		proceedButton.configuration?.title = "Proceed to chats"
		addSubview(proceedButton)
	}
	
	func setupConstraints() {
		backgroundColorButton.translatesAutoresizingMaskIntoConstraints = false
		textSizeLabel.translatesAutoresizingMaskIntoConstraints = false
		textSizeStepper.translatesAutoresizingMaskIntoConstraints = false
		cornerRadiusLabel.translatesAutoresizingMaskIntoConstraints = false
		cornerRadiusSlider.translatesAutoresizingMaskIntoConstraints = false
		proceedButton.translatesAutoresizingMaskIntoConstraints = false
		
		textSizeStepper.setContentCompressionResistancePriority(.required, for: .horizontal)
		
		NSLayoutConstraint.activate([
			backgroundColorButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Size.paddingHorizontal),
			backgroundColorButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.Size.paddingVertical),
			backgroundColorButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Size.paddingHorizontal),
			backgroundColorButton.heightAnchor.constraint(equalToConstant: Constants.Size.buttonDimention),
			
			textSizeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Size.paddingHorizontal),
			textSizeLabel.topAnchor.constraint(equalTo: backgroundColorButton.bottomAnchor, constant: Constants.Size.paddingVertical),
			textSizeLabel.trailingAnchor.constraint(lessThanOrEqualTo: textSizeStepper.leadingAnchor, constant: -Constants.Size.paddingHorizontal),
			
			textSizeStepper.topAnchor.constraint(equalTo: backgroundColorButton.bottomAnchor, constant: Constants.Size.paddingVertical),
			textSizeStepper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Size.paddingHorizontal),
			
			cornerRadiusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Size.paddingHorizontal),
			cornerRadiusLabel.topAnchor.constraint(greaterThanOrEqualTo: textSizeLabel.bottomAnchor, constant: Constants.Size.paddingVertical),
			cornerRadiusLabel.topAnchor.constraint(greaterThanOrEqualTo: textSizeStepper.bottomAnchor, constant: Constants.Size.paddingVertical),
			cornerRadiusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Size.paddingHorizontal),
			
			cornerRadiusSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Size.paddingHorizontal),
			cornerRadiusSlider.topAnchor.constraint(equalTo: cornerRadiusLabel.bottomAnchor, constant: Constants.Size.paddingVertical),
			cornerRadiusSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Size.paddingHorizontal),
			
			proceedButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Size.paddingHorizontal),
			proceedButton.topAnchor.constraint(equalTo: cornerRadiusSlider.bottomAnchor, constant: Constants.Size.paddingVertical),
			proceedButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.Size.paddingHorizontal),
			proceedButton.heightAnchor.constraint(equalToConstant: Constants.Size.buttonDimention)
		])
	}
	
	func setupBindings() {
		viewModel.$backgroundColor
			.receive(on: DispatchQueue.main)
			.sink { [unowned self] backgroundColor in
				backgroundColorButton.backgroundColor = backgroundColor
				backgroundColorButton.tintColor = backgroundColor.inverted
				proceedButton.backgroundColor = backgroundColor
				proceedButton.tintColor = backgroundColor.inverted
			}
			.store(in: &cancellables)
		
		viewModel.$cornerRadius
			.receive(on: DispatchQueue.main)
			.sink { [unowned self] cornerRadius in
				backgroundColorButton.layer.cornerRadius = cornerRadius
				proceedButton.layer.cornerRadius = cornerRadius
				cornerRadiusSlider.value = Float(cornerRadius)
				cornerRadiusLabel.text = "Corner radius is \(Int(viewModel.cornerRadius)) points"
			}
			.store(in: &cancellables)
		
		viewModel.$textSize
			.receive(on: DispatchQueue.main)
			.sink { [unowned self] textSize in
				textSizeLabel.text = "Text size is \(Int(viewModel.textSize)) points"
				textSizeLabel.font = .systemFont(ofSize: textSize)
			}
			.store(in: &cancellables)
	}
}

extension ConfigurationView {
	
	@objc func cornerRadiusStepperValueChanged(_ stepper: UIStepper) {
		viewModel.textSize = stepper.value
	}
	
	@objc func cornerRadiusSliderValueChanged(_ slider: UISlider) {
		viewModel.cornerRadius = CGFloat(Int(slider.value))
	}
}
