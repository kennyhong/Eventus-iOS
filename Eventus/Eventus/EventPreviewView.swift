//
//  EventPreviewView.swift
//  Eventus
//
//  Created by Kieran on 2017-02-09.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

protocol EventPreviewViewDelegate {
	func didTouchEventPreviewView(withEventId id: Int)
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
	
	var name: String? {
		didSet {
			nameLabel.text = name
			nameLabel.isHidden = name == nil
		}
	}
	
	var eventDescription: String? {
		didSet {
			eventDescriptionLabel.text = eventDescription
			eventDescriptionLabel.isHidden = eventDescription == nil
		}
	}
	
	var date: String? {
		didSet {
			dateLabel.text = date
			dateLabel.isHidden = date == nil
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
		guard let id = id else { fatalError("event has no associated id") }
		delegate?.didTouchEventPreviewView(withEventId: id)
	}
}
