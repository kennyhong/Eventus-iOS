import UIKit

protocol EventDetailsViewControllerDelegate {
	func didModifyEvent(event: Event)
	func didDeleteEvent(withId id: Int)
}

class EventDetailsViewController: UIViewController {
	
	fileprivate let currentEvent: Event?
	fileprivate let titleLabel = UILabel()
	fileprivate let descriptionLabel = UILabel()
	fileprivate let dateLabel = UILabel()
	fileprivate let servicesButton = ButtonWithImageView()
	fileprivate let invoiceButton = ButtonWithImageView()
	fileprivate let shareOnFacebookButton = ButtonWithImageView()
	fileprivate let deleteEventButton = Button(withMargins: UIEdgeInsets(horizontal: .large, vertical: .medium + .small))
	var delegate: EventDetailsViewControllerDelegate?
	
	init(withEvent event: Event) {
		currentEvent = event
		super.init(nibName: nil, bundle: nil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		view.backgroundColor = .white
		title = "Event Details"
		
		let editBarItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTouched))
		navigationItem.rightBarButtonItem = editBarItem
		
		setupTitleLabel()
		setupDescriptionLabel()
		setupDateLabel()
		setupServicesButton()
		setupInvoiceButton()
		setupShareOnFacebookButton()
		setupDeleteEventButton()
		updateTotals()
	}
	
	private func setupTitleLabel() {
		titleLabel.text = currentEvent!.name
		titleLabel.fontSize(of: .largeFont)
		titleLabel.textAlignment = .center
		view.addSubviewForAutolayout(titleLabel)
		titleLabel.constrainToFillViewHorizontally(view)
		titleLabel.pinInsideTopOf(view: view, constant: .medium)
	}
	
	private func setupDescriptionLabel() {
		descriptionLabel.text = currentEvent!.eventDescription
		descriptionLabel.numberOfLines = 0
		descriptionLabel.fontSize(of: .verySmallFont)
		descriptionLabel.textColor = .lightGray
		descriptionLabel.textAlignment = .center
		view.addSubviewForAutolayout(descriptionLabel)
		descriptionLabel.constrainToFillViewHorizontally(view, withMargins: .medium)
		descriptionLabel.pinToBottomOfView(view: titleLabel, constant: .medium)
	}
	
	private func setupDateLabel() {
		dateLabel.text = currentEvent!.date
		dateLabel.numberOfLines = 0
		dateLabel.fontSize(of: .verySmallFont)
		dateLabel.textAlignment = .center
		view.addSubviewForAutolayout(dateLabel)
		dateLabel.constrainToFillViewHorizontally(view, withMargins: .medium)
		dateLabel.pinToBottomOfView(view: descriptionLabel, constant: .medium)
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
		servicesButton.pinToBottomOfView(view: dateLabel, constant: .extraLarge)
	}
	
	private func setupInvoiceButton() {
		invoiceButton.text = "Invoice"
		invoiceButton.image = #imageLiteral(resourceName: "right-chevron")
		invoiceButton.backgroundColor = .white
		invoiceButton.addBottomSeparator()
		invoiceButton.delegate = self
		view.addSubviewForAutolayout(invoiceButton)
		invoiceButton.constrainToFillViewHorizontally(view)
		invoiceButton.pinToBottomOfView(view: servicesButton)
	}
	
	private func setupShareOnFacebookButton() {
		shareOnFacebookButton.text = "Share on Facebook"
		shareOnFacebookButton.image = #imageLiteral(resourceName: "right-chevron")
		shareOnFacebookButton.backgroundColor = .white
		shareOnFacebookButton.addBottomSeparator()
		shareOnFacebookButton.delegate = self
		view.addSubviewForAutolayout(shareOnFacebookButton)
		shareOnFacebookButton.constrainToFillViewHorizontally(view)
		shareOnFacebookButton.pinToBottomOfView(view: invoiceButton)
	}
	
	private func setupDeleteEventButton() {
		deleteEventButton.setTitle("Delete Event", for: .normal)
		deleteEventButton.setTitleColor(.cancel, for: .normal)
		deleteEventButton.titleLabel?.textAlignment = .center
		deleteEventButton.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
		deleteEventButton.addTopSeparator()
		deleteEventButton.addBottomSeparator()
		view.addSubviewForAutolayout(deleteEventButton)
		deleteEventButton.pinToBottomOfView(view: shareOnFacebookButton, constant: .extraLarge)
		deleteEventButton.constrainToFillViewHorizontally(view)
	}
	
	fileprivate func updateTotals(addingService service: Service? = nil) {
		if isTesting {
			if service != nil {
				self.currentEvent!.subTotal! += service!.cost!
				self.currentEvent!.tax! += service!.cost! * 0.13
				self.currentEvent!.total! += service!.cost! * 1.13
			}
		} else {
			let url = URL(string: "http://eventus.us-west-2.elasticbeanstalk.com/api/events/\(currentEvent!.id!)/invoice")
			let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
				do {
					if let data = data,
						let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
						let event = json["data"] as? [String : Any] {
						
						self.currentEvent!.subTotal = event["sub_total"] as? Double
						self.currentEvent!.tax = event["tax"] as? Double
						self.currentEvent!.total = event["grand_total"] as? Double
					}
				} catch {
					print("Error deserializing JSON: \(error)")
				}
			}
			task.resume()
		}
	}
	
	@objc private func editTouched() {
		let createEventViewController = CreateEventViewController(modifyingEvent: currentEvent!)
		createEventViewController.delegate = self
		let createEventNavigationController = UINavigationController(rootViewController: createEventViewController)
		createEventNavigationController.navigationBar.isTranslucent = false
		present(createEventNavigationController, animated: true, completion: nil)
	}
	
	@objc private func didTapDelete() {
		let alertController = UIAlertController(title: "Delete Event", message: "Are you sure you want to delete your event?", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alert: UIAlertAction) -> Void in
			
			if !isTesting {
				self.request(withString: "http://eventus.us-west-2.elasticbeanstalk.com/api/events/\(self.currentEvent!.id!)", requestType: "DELETE") { response in
					
					print("response = \(String(describing: response))")
				}
			}
			self.dismiss(animated: true, completion: nil)
			self.delegate?.didDeleteEvent(withId: self.currentEvent!.id!)
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
				let currentServicesListViewController = CurrentServicesListViewController(withEventId: currentEvent!.id!)
				currentServicesListViewController.delegate = self
				viewController = currentServicesListViewController
			case invoiceButton:
				viewController = EventInvoiceViewController(withEvent: currentEvent!)
			case shareOnFacebookButton:
				viewController = ShareEventOnFacebookViewController(withEvent: currentEvent!)
			default:
				fatalError("unknown sender")
		}
		navigationController?.pushViewController(viewController, animated: true)
	}
}

extension EventDetailsViewController: CreateEventViewControllerDelegate {
	
	func didCreateEvent(event: Event) {
		delegate?.didModifyEvent(event: event)
		DispatchQueue.main.async {
			self.titleLabel.text = event.name
			self.descriptionLabel.text = event.eventDescription
			self.dateLabel.text = event.date
		}
	}
}

extension EventDetailsViewController: CurrentServicesListViewControllerDelegate {
	
	func didAddService(_ service: Service) {
		currentEvent!.services.append(service)
		updateTotals(addingService: service)
	}
	
	func didDeleteService(withId id: Int) {
		currentEvent!.services = currentEvent!.services.filter() { ($0 as Service).id != id }
		updateTotals()
	}
}
