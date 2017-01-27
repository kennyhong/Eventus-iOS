//
//  UIStackViewExtensions.swift
//  Eventus
//
//  Created by Kieran on 2017-01-27.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

public extension UIStackView {
	
	public convenience init(axis: UILayoutConstraintAxis = .horizontal,
	                        alignment: UIStackViewAlignment = .fill,
	                        distribution: UIStackViewDistribution = .fill,
	                        spacing: CGFloat = 0) {
		self.init()
		self.axis = axis
		self.alignment = alignment
		self.distribution = distribution
		self.spacing = spacing
	}
	
	public func addArrangedSubviews(_ views: UIView...) {
		views.forEach {
			self.addArrangedSubview($0)
		}
	}
}
