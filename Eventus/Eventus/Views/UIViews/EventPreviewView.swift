import UIKit

protocol EventPreviewViewDelegate {
	func didTouchEventPreviewView(withEvent event: Event)
}

class EventPreviewView: UIView, UIGestureRecognizerDelegate {
	
	fileprivate let stackView = UIStackView(axis: .vertical, distribution: .fillProportionally)
	fileprivate let nameLabel = UILabel()
	fileprivate let eventDescriptionLabel = UILabel()
	fileprivate let dateLabel = UILabel()
	var delegate: EventPreviewViewDelegate?
	var id: Int?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var event: Event? {
		didSet {
			guard let event = event else { return }
			
			nameLabel.text = event.name
			nameLabel.isHidden = event.name == nil
			
			eventDescriptionLabel.text = event.eventDescription
			eventDescriptionLabel.isHidden = event.eventDescription == nil
			
			dateLabel.text = event.date
			dateLabel.isHidden = event.date == nil
		}
	}
	
	private func setup() {
		backgroundColor = .white
		let tap = UITapGestureRecognizer(target: self, action: #selector(didTouchEventPreviewView))
		tap.delegate = self
		self.addGestureRecognizer(tap)
		
		setupStackView()
		setupNameLabel()
		setupEventDescriptionLabel()
		setupDateLabel()
	}
	
	private func setupStackView() {
		stackView.isLayoutMarginsRelativeArrangement = true
		stackView.layoutMargins = UIEdgeInsets(horizontal: .medium, vertical: .small)
		addSubviewForAutolayout(stackView)
		stackView.constrainToFillView(self)
	}
	
	private func setupNameLabel() {
		nameLabel.numberOfLines = 0
		stackView.addArrangedSubview(nameLabel)
	}
	
	private func setupEventDescriptionLabel() {
		eventDescriptionLabel.numberOfLines = 0
		stackView.addArrangedSubview(eventDescriptionLabel)
	}
	
	private func setupDateLabel() {
		dateLabel.numberOfLines = 0
		stackView.addArrangedSubview(dateLabel)
	}
	
	@objc private func didTouchEventPreviewView() {
		delegate?.didTouchEventPreviewView(withEvent: event!)
	}
}
