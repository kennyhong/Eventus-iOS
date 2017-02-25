//
//  EventPreviewView.swift
//  Eventus
//
//  Created by Kieran on 2017-02-09.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

class EventPreviewView: UIView {
	
	fileprivate let stackView = UIStackView(axis: .vertical)
	fileprivate let nameLabel = UILabel()
	fileprivate let eventDescriptionLabel = UILabel()
	fileprivate let dateLabel = UILabel()
	
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
		stackView.addArrangedSubview(nameLabel)
	}
	
	private func setupEventDescriptionLabel() {
		stackView.addArrangedSubview(eventDescriptionLabel)
	}
	
	private func setupDateLabel() {
		stackView.addArrangedSubview(dateLabel)
	}
}
