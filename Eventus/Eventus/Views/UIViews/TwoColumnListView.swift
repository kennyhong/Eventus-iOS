import UIKit

class TwoColumnListView: UIView {
	
	fileprivate let stackView = UIStackView(axis: .vertical, spacing: .verySmall)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		setupStackView()
	}
	
	private func setupStackView() {
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.layoutMargins = UIEdgeInsets(horizontal: .medium, vertical: .small)
		addSubviewForAutolayout(stackView)
		stackView.constrainToFillView(self)
	}
	
	func addRowWith(leftColumnString: String, rightColumnString: String, withAttributes attributes: [String : Any]? = nil) {
		let rowStackView = UIStackView(distribution: .fillProportionally)
		
		let leftLabel = UILabel()
		leftLabel.text = leftColumnString
		leftLabel.textAlignment = .left
		if attributes != nil {
			leftLabel.setAttributes(attributes)
		}
		rowStackView.addArrangedSubview(leftLabel)
		
		let rightLabel = UILabel()
		rightLabel.text = rightColumnString
		rightLabel.textAlignment = .right
		if attributes != nil {
			rightLabel.setAttributes(attributes)
		}
		rowStackView.addArrangedSubview(rightLabel)
		
		stackView.addArrangedSubview(rowStackView)
	}
}
