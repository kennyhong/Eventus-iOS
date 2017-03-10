import UIKit

protocol EventDetailsViewControllerDelegate {
	func didDeleteEvent(withId id: Int)
}

class EventDetailsViewController: UIViewController {
	
	fileprivate let currentEvent = Event()
	fileprivate let eventId: Int
	fileprivate let titleLabel = UILabel()
	fileprivate let descriptionLabel = UILabel()
	fileprivate let servicesButton = ButtonWithImageView()
	fileprivate let deleteEventButton = Button(withMargins: UIEdgeInsets(horizontal: .large, vertical: .medium + .small))
	var delegate: EventDetailsViewControllerDelegate?
	
	init(withEventId id: Int) {
		eventId = id
		super.init(nibName: nil, bundle: nil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		view.backgroundColor = .white
		title = "Event Details"
		
		if isTesting {
			titleLabel.text = "test-title"
			descriptionLabel.text = "test-description"
		} else {
			let url = URL(string: "http://eventus.us-west-2.elasticbeanstalk.com/api/events/\(eventId)")
			let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
				do {
					if let data = data,
						let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
						let event = json["data"] as? [String: Any] {
						
						self.currentEvent.id = event["id"] as? Int
						self.currentEvent.name = event["name"] as? String
						self.currentEvent.eventDescription = event["description"] as? String
						
						DispatchQueue.main.async {
							self.titleLabel.text = self.currentEvent.name
							self.descriptionLabel.text = self.currentEvent.eventDescription
						}
					}
				} catch {
					print("Error deserializing JSON: \(error)")
				}
			}
			task.resume()
		}
		
		setupTitleLabel()
		setupDescriptionLabel()
		setupServicesButton()
		setupDeleteEventButton()
	}
	
	private func setupTitleLabel() {
		titleLabel.fontSize(of: .largeFont)
		titleLabel.textAlignment = .center
		view.addSubviewForAutolayout(titleLabel)
		titleLabel.constrainToFillViewHorizontally(view)
		titleLabel.pinInsideTopOf(view: view, constant: .medium)
	}
	
	private func setupDescriptionLabel() {
		descriptionLabel.numberOfLines = 0
		descriptionLabel.fontSize(of: .verySmallFont)
		descriptionLabel.textColor = .lightGray
		descriptionLabel.textAlignment = .center
		view.addSubviewForAutolayout(descriptionLabel)
		descriptionLabel.constrainToFillViewHorizontally(view, withMargins: .medium)
		descriptionLabel.pinToBottomOfView(view: titleLabel, constant: .medium)
	}
	
	private func setupServicesButton() {
		servicesButton.text = "Services"
		servicesButton.image = #imageLiteral(resourceName: "right-chevron")
		servicesButton.backgroundColor = .white
		servicesButton.addTopSeparator()
		servicesButton.addBottomSeparator()
		servicesButton.delegate = self
		view.addSubviewForAutolayout(servicesButton)
		servicesButton.constrainToFillViewHorizontally(view)
		servicesButton.pinToBottomOfView(view: descriptionLabel, constant: .extraLarge)
	}
	
	private func setupDeleteEventButton() {
		deleteEventButton.setTitle("Delete Event", for: .normal)
		deleteEventButton.setTitleColor(.cancel, for: .normal)
		deleteEventButton.titleLabel?.textAlignment = .center
		deleteEventButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
		deleteEventButton.addTopSeparator()
		deleteEventButton.addBottomSeparator()
		view.addSubviewForAutolayout(deleteEventButton)
		deleteEventButton.pinToBottomOfView(view: servicesButton, constant: .extraLarge)
		deleteEventButton.constrainToFillViewHorizontally(view)
	}
	
	@objc private func didTapDelete() {
		let alertController = UIAlertController(title: "Delete Event", message: "Are you sure you want to delete your event?", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alert: UIAlertAction) -> Void in
			
			if !isTesting {
				self.request(withString: "http://eventus.us-west-2.elasticbeanstalk.com/api/events/\(self.eventId)", requestType: "DELETE") { response in
					
					print("response = \(response)")
				}
			}
			self.dismiss(animated: true, completion: nil)
			self.delegate?.didDeleteEvent(withId: self.eventId)
			_ = self.navigationController?.popViewController(animated: true)
		}))
		alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
		present(alertController, animated: true, completion: nil)
	}
}

extension EventDetailsViewController: ButtonWithImageViewDelegate {
	
	func didTapButton(sender: ButtonWithImageView) {
		let viewController: UIViewController
		switch sender {
		case servicesButton:
			viewController = CurrentServicesListViewController(withEventId: eventId)
		default:
			fatalError("unknown sender")
		}
		navigationController?.pushViewController(viewController, animated: true)
	}
}
