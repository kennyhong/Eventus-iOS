//
//  UIEdgeInsetsExtensions.swift
//  Eventus
//
//  Created by Kieran on 2017-01-27.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
	
	static let doubleExtraLarge = UIEdgeInsets(equalSpacing: .doubleExtraLarge)
	static let extraLarge = UIEdgeInsets(equalSpacing: .extraLarge)
	static let large = UIEdgeInsets(equalSpacing: .large)
	static let medium = UIEdgeInsets(equalSpacing: .medium)
	static let small = UIEdgeInsets(equalSpacing: .small)
	static let verySmall = UIEdgeInsets(equalSpacing: .verySmall)
	
	private init(equalSpacing spacing: CGFloat) {
		self.init(top: spacing, left: spacing, bottom: spacing, right: spacing)
	}
	
	public init(horizontal: CGFloat = .zero, vertical: CGFloat = .zero) {
		self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
	}
	
	// have to order parameters like this to avoid infinite recursion with factory initializer
	public init(left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0, top: CGFloat = 0) {
		self.init(top: top, left: left, bottom: bottom, right: right)
	}
}
