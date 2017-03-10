import UIKit

protocol TextFieldWithButtonViewDelegate {
	func didTriggerSubmit(withText: String)
}

class TextFieldWithButtonView: UIView {
	
	fileprivate let stackView = UIStackView(spacing: .verySmall)
	fileprivate let textField = TextField(withPadding: UIEdgeInsets(horizontal: .extraLarge, vertical: .large))
	fileprivate let submitButton = Button(withMargins: UIEdgeInsets(horizontal: .extraLarge, vertical: .large))
	var delegate: TextFieldWithButtonViewDelegate?
	
	var buttonBackgroundColor: UIColor? {
		didSet {
			submitButton.backgroundColor = .white
		}
	}
	
	var buttonTitleColor: UIColor? {
		didSet {
			submitButton.setTitleColor(.eventusGreen, for: .normal)
		}
	}
	
	var textFieldPlaceholder: String? {
		didSet {
			guard let placeholder = textFieldPlaceholder else { return }
			textField.placeholder = placeholder
		}
	}
	
	var text: String? {
		get {
			return textField.text
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		setupStackView()
		setupTextField()
		setupSubmitButton()
		
		layer.cornerRadius = textField.intrinsicContentSize.height / 2
		layer.masksToBounds = true
	}
	
	private func setupStackView() {
		addSubviewForAutolayout(stackView)
		stackView.constrainToFillView(self)
	}
	
	private func setupTextField() {
		textField.delegate = self
		textField.backgroundColor = .white
		textField.fontSize(of: .largeFont)
		textField.returnKeyType = .go
		stackView.addArrangedSubview(textField)
	}
	
	private func setupSubmitButton() {
		submitButton.addTarget(self, action: #selector(didTapSubmitButton), for: .touchUpInside)
		submitButton.setTitle(">", for: .normal)
		submitButton.titleLabel?.fontSize(of: .largeFont)
		submitButton.widthAnchor.constraint(equalToConstant: textField.intrinsicContentSize.height).isActive = true
		stackView.addArrangedSubview(submitButton)
	}
	
	@objc private func didTapSubmitButton() {
		if !textField.text!.isEmpty {
			delegate?.didTriggerSubmit(withText: textField.text!)
		}
	}
}

extension TextFieldWithButtonView: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if !textField.text!.isEmpty {
			delegate?.didTriggerSubmit(withText: textField.text!)
			textField.resignFirstResponder()
		}
		return true
	}
}
