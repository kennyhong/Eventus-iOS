//
//  ButtonWithImageView.swift
//  Eventus
//
//  Created by Kieran on 2017-03-03.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

protocol ButtonWithImageViewDelegate {
	func didTapButton(sender: ButtonWithImageView)
}

class ButtonWithImageView: UIView {
	
	var delegate: ButtonWithImageViewDelegate?
	fileprivate let stackView = UIStackView(distribution: .equalSpacing)
	fileprivate let label = UILabel()
	fileprivate let imageView = UIImageView()
	fileprivate let button = Button()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
		setupButton()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var text: String? {
		didSet {
			label.text = text
			label.isHidden = text == nil
		}
	}
	
	var image: UIImage? {
		didSet {
			imageView.image = image
		}
	}
	
	private func setup() {
		setupStackView()
	}
	
	private func setupStackView() {
		addSubviewForAutolayout(stackView)
		stackView.constrainToFillView(self)
		stackView.layoutMargins = UIEdgeInsets(horizontal: .large, vertical: .medium + .small)
		stackView.isLayoutMarginsRelativeArrangement = true
		
		setupImageView()
		stackView.addArrangedSubviews(label, imageView)
	}
	
	private func setupButton() {
		addSubviewForAutolayout(button)
		button.constrainToFillView(self)
		button.shouldMakeParentTranslucentOnHighlight = true
		button.addTarget(self, action: #selector(tappedButton), for: .touchUpInside)
	}
	
	@objc private func tappedButton() {
		delegate?.didTapButton(sender: self)
	}
	
	private func setupImageView() {
		imageView.widthAnchor.constraint(equalToConstant: .iconWidth).isActive = true
		imageView.heightAnchor.constraint(equalToConstant: .iconWidth).isActive = true
	}
}
