import UIKit

class TextFieldWithImageView: UIView {
	
	fileprivate let stackView = UIStackView(alignment: .center, spacing: .medium)
	fileprivate let imageView = UIImageView()
	let textField = TextField(withPadding: UIEdgeInsets(top: .small, left: 0, bottom: .small, right: 0))
	fileprivate let separator = HorizontalSeparator()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var image: UIImage? {
		didSet {
			imageView.image = image
		}
	}
	
	var stackViewLayoutMargins: UIEdgeInsets? {
		didSet {
			guard let margins = stackViewLayoutMargins else { return }
			stackView.layoutMargins = margins
		}
	}
	
	private func setup() {
		setupStackView()
		setupImageView()
		setupTextField()
	}
	
	private func setupStackView() {
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.layoutMargins = UIEdgeInsets(horizontal: .large, vertical: .medium + .small)
		addSubviewForAutolayout(stackView)
		stackView.constrainToFillView(self)
	}
	
	private func setupImageView() {
		imageView.heightAnchor.constraint(equalToConstant: .iconWidth).isActive = true
		imageView.widthAnchor.constraint(equalToConstant: .iconWidth).isActive = true
		stackView.addArrangedSubview(imageView)
	}
	
	private func setupTextField() {
		textField.addBottomSeparator()
		textField.addSubviewForAutolayout(separator)
		separator.pinToBottomOfView(view: textField)
		separator.constrainToFillViewHorizontally(textField)
		stackView.addArrangedSubview(textField)
	}
}
