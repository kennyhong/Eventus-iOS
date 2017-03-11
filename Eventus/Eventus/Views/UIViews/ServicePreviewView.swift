import UIKit

protocol ServicePreviewViewDelegate {
	func didTouchServicePreviewView(withServiceId id: Int)
}

class ServicePreviewView: UIView, UIGestureRecognizerDelegate {
	
	fileprivate let stackView = UIStackView(axis: .vertical, distribution: .fillProportionally)
	fileprivate let nameLabel = UILabel()
	fileprivate let costLabel = UILabel()
	var delegate: ServicePreviewViewDelegate?
	var id: Int?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var name: String? {
		didSet {
			nameLabel.text = name
			nameLabel.isHidden = name == nil
		}
	}
	
	var cost: Int? {
		didSet {
			costLabel.isHidden = cost == nil
			guard let cost = cost else { return }
			costLabel.text = "cost: $\(cost)"
		}
	}
	
	private func setup() {
		backgroundColor = .white
		let tap = UITapGestureRecognizer(target: self, action: #selector(didTouchServicePreviewView))
		tap.delegate = self
		self.addGestureRecognizer(tap)
		
		setupStackView()
		setupNameLabel()
		setupCostLabel()
	}
	
	private func setupStackView() {
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.layoutMargins = UIEdgeInsets(horizontal: .medium, vertical: .small)
		addSubviewForAutolayout(stackView)
		stackView.constrainToFillView(self)
	}
	
	private func setupNameLabel() {
		stackView.addArrangedSubview(nameLabel)
	}
	
	private func setupCostLabel() {
		stackView.addArrangedSubview(costLabel)
	}
	
	@objc private func didTouchServicePreviewView() {
		guard let id = id else { fatalError("event has no associated id") }
		delegate?.didTouchServicePreviewView(withServiceId: id)
	}
}
