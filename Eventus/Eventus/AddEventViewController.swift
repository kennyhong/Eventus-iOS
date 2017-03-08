//
//  AddEventViewController.swift
//  Eventus
//
//  Created by Kieran on 2017-03-07.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

protocol AddEventViewControllerDelegate {
	func didAddEvent(event: Event)
}

class AddEventViewController: UIViewController {
	
	var delegate: AddEventViewControllerDelegate?
	fileprivate let nameTextFieldWithImageView = TextFieldWithImageView()
	fileprivate let descriptionTextFieldWithImageView = TextFieldWithImageView()
	fileprivate let dateTextFieldWithImageView = TextFieldWithImageView()
	fileprivate let datePickerView = UIDatePicker()
	
	init() {
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
		
		setupDatePickerView()
		setupNameTextFieldWithImageView()
		setupDescriptionTextFieldWithImageView()
		setupDateTextFieldWithImageView()
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
	
	@objc private func saveTouched() {
		if !areFieldsPopulated() {
			let alertController = UIAlertController(title: "Incomplete Event", message: "You can't create an event with empty fields. Continuing will not create the event and lose changes.", preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { (alert: UIAlertAction) -> Void in
				self.resignFirstResponder()
				self.dismiss(animated: true, completion: nil)
			}))
			alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
			present(alertController, animated: true, completion: nil)
		} else {
			if isTesting {
				self.delegate?.didAddEvent(event: Event(id: 123, name: nameTextFieldWithImageView.textField.text!, eventDescription: descriptionTextFieldWithImageView.textField.text!, date: "\(dateTextFieldWithImageView.textField.text!) 00:00:00"))
				self.resignFirstResponder()
				self.dismiss(animated: true, completion: nil)
			} else {
				let json = ["name": nameTextFieldWithImageView.textField.text!,
				            "description": descriptionTextFieldWithImageView.textField.text!,
				            "date": "\(dateTextFieldWithImageView.textField.text!) 00:00:00"]
				request(withString: "http://eventus.us-west-2.elasticbeanstalk.com/api/events", requestType: "POST", json: json) { response in
					
					if let response = response {
						let event = response["data"] as! [String: Any]
						self.delegate?.didAddEvent(event: Event(id: event["id"] as? Int, name: event["name"] as? String, eventDescription: event["description"] as? String, date: event["date"] as? String))
					} else {
						print("Error: failure in creating new event")
					}
					self.resignFirstResponder()
					self.dismiss(animated: true, completion: nil)
				}
			}
		}
	}
	
	@objc private func cancelTouched() {
		self.resignFirstResponder()
		self.dismiss(animated: true, completion: nil)
	}
	
	@objc fileprivate func formatDate() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		dateTextFieldWithImageView.textField.text = dateFormatter.string(from: datePickerView.date)
	}
}

extension AddEventViewController: UITextFieldDelegate {
	
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
