import UIKit

protocol CreateEventViewControllerDelegate {
	func didCreateEvent(event: Event)
}

class CreateEventViewController: UIViewController {
	
	var delegate: CreateEventViewControllerDelegate?
	fileprivate let nameTextFieldWithImageView = TextFieldWithImageView()
	fileprivate let descriptionTextFieldWithImageView = TextFieldWithImageView()
	fileprivate let dateTextFieldWithImageView = TextFieldWithImageView()
	fileprivate let datePickerView = UIDatePicker()
	fileprivate let dateFormatter = DateFormatter()
	fileprivate let oldEvent: Event?
	
	init(modifyingEvent event: Event? = nil) {
		oldEvent = event
		super.init(nibName: nil, bundle: nil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		hideKeyboardWhenViewTapped()
		view.backgroundColor = .white
		title = "Add Event"
		let cancelBarItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTouched))
		navigationItem.leftBarButtonItem = cancelBarItem
		let doneBarItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTouched))
		navigationItem.rightBarButtonItem = doneBarItem
		
		setupDateFormatter()
		setupDatePickerView()
		setupNameTextFieldWithImageView()
		setupDescriptionTextFieldWithImageView()
		setupDateTextFieldWithImageView()
		updateIfEditing()
	}
	
	private func setupDateFormatter() {
		dateFormatter.dateFormat = "MMM d, yyyy"
	}
	
	private func setupDatePickerView() {
		datePickerView.datePickerMode = .date
	}
	
	private func setupNameTextFieldWithImageView() {
		nameTextFieldWithImageView.textField.delegate = self
		nameTextFieldWithImageView.textField.returnKeyType = .next
		nameTextFieldWithImageView.image = #imageLiteral(resourceName: "title")
		nameTextFieldWithImageView.textField.placeholder = "Name"
		nameTextFieldWithImageView.stackViewLayoutMargins = UIEdgeInsets(horizontal: .doubleExtraLarge, vertical: .medium + .small)
		view.addSubviewForAutolayout(nameTextFieldWithImageView)
		nameTextFieldWithImageView.pinInsideTopOf(view: view, constant: .large)
		nameTextFieldWithImageView.constrainToFillViewHorizontally(view)
	}
	
	private func setupDescriptionTextFieldWithImageView() {
		descriptionTextFieldWithImageView.textField.delegate = self
		descriptionTextFieldWithImageView.textField.returnKeyType = .next
		descriptionTextFieldWithImageView.image = #imageLiteral(resourceName: "info")
		descriptionTextFieldWithImageView.textField.placeholder = "Description"
		descriptionTextFieldWithImageView.stackViewLayoutMargins = UIEdgeInsets(horizontal: .doubleExtraLarge, vertical: .medium + .small)
		view.addSubviewForAutolayout(descriptionTextFieldWithImageView)
		descriptionTextFieldWithImageView.pinToBottomOfView(view: nameTextFieldWithImageView, constant: .large)
		descriptionTextFieldWithImageView.constrainToFillViewHorizontally(view)
	}
	
	private func setupDateTextFieldWithImageView() {
		dateTextFieldWithImageView.textField.delegate = self
		dateTextFieldWithImageView.image = #imageLiteral(resourceName: "calendar-bigger")
		dateTextFieldWithImageView.textField.placeholder = "Date"
		dateTextFieldWithImageView.stackViewLayoutMargins = UIEdgeInsets(horizontal: .doubleExtraLarge, vertical: .medium + .small)
		view.addSubviewForAutolayout(dateTextFieldWithImageView)
		dateTextFieldWithImageView.pinToBottomOfView(view: descriptionTextFieldWithImageView, constant: .large)
		dateTextFieldWithImageView.constrainToFillViewHorizontally(view)
	}
	
	private func areFieldsPopulated() -> Bool {
		return !nameTextFieldWithImageView.textField.text!.isEmpty && !descriptionTextFieldWithImageView.textField.text!.isEmpty && !dateTextFieldWithImageView.textField.text!.isEmpty
	}
	
	private func updateIfEditing() {
		if oldEvent != nil {
			nameTextFieldWithImageView.textField.text = oldEvent?.name
			descriptionTextFieldWithImageView.textField.text = oldEvent?.eventDescription
			dateTextFieldWithImageView.textField.text = oldEvent?.date
			datePickerView.setDate(dateFormatter.date(from: oldEvent!.date!)!, animated: false)
		}
	}
	
	@objc private func saveTouched() {
		if !areFieldsPopulated() {
			let alertMessage = "You can't create/edit an event with empty fields. Continuing will not create the event and lose changes."
			let alertController = UIAlertController(title: "Incomplete Event", message: alertMessage, preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { (alert: UIAlertAction) -> Void in
				self.resignFirstResponder()
				self.dismiss(animated: true, completion: nil)
			}))
			alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
			present(alertController, animated: true, completion: nil)
		} else {
			if isTesting {
				self.delegate?.didCreateEvent(event: Event(id: 123,
				                                           name: nameTextFieldWithImageView.textField.text!,
				                                           eventDescription: descriptionTextFieldWithImageView.textField.text!,
				                                           date: dateTextFieldWithImageView.textField.text!,
				                                           subTotal: 0.0,
				                                           tax: 0.0,
				                                           total: 0.0))
				self.resignFirstResponder()
				self.dismiss(animated: true, completion: nil)
			} else {
				let json = ["name": nameTextFieldWithImageView.textField.text!,
				            "description": descriptionTextFieldWithImageView.textField.text!,
				            "date": dateFormatter.jsonString(from: dateTextFieldWithImageView.textField.text!)!.components(separatedBy: " ").first!]
				
				let (urlString, requestType) = setRequestParams()
				request(withString: urlString, requestType: requestType, json: json) { response in
					
					if let response = response {
						let event = response["data"] as! [String: Any]
						self.delegate?.didCreateEvent(event: Event(id: event["id"] as? Int,
						                                           name: event["name"] as? String,
						                                           eventDescription: event["description"] as? String,
						                                           date: self.dateFormatter.englishDate(from: event["date"] as? String)))
					} else {
						print("Error: failure in creating new event")
					}
					
					self.resignFirstResponder()
					self.dismiss(animated: true, completion: nil)
				}
			}
		}
	}
	
	private func setRequestParams() -> (String, String) {
		let urlString: String?
		let requestType: String?
		if oldEvent != nil {
			urlString = "http://eventus.us-west-2.elasticbeanstalk.com/api/events/\(oldEvent!.id!)"
			requestType = "PATCH"
		} else {
			urlString = "http://eventus.us-west-2.elasticbeanstalk.com/api/events"
			requestType = "POST"
		}
		return (urlString!, requestType!)
	}
	
	@objc private func cancelTouched() {
		self.resignFirstResponder()
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc fileprivate func formatDate() {
		dateTextFieldWithImageView.textField.text = dateFormatter.string(from: datePickerView.date)
	}
}

extension CreateEventViewController: UITextFieldDelegate {
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		if textField == dateTextFieldWithImageView.textField {
			textField.inputView = datePickerView
			datePickerView.addTarget(self, action: #selector(formatDate), for: .valueChanged)
		}
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		if textField == nameTextFieldWithImageView.textField {
			descriptionTextFieldWithImageView.textField.becomeFirstResponder()
		} else if textField == descriptionTextFieldWithImageView.textField {
			dateTextFieldWithImageView.textField.becomeFirstResponder()
		}
		return true
	}
}
