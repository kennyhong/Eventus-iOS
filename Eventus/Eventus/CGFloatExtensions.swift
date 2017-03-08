//
//  CGFloatExtensions.swift
//  Eventus
//
//  Created by Kieran on 2017-01-27.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

public extension CGFloat {
	
	// MARK: Font Sizing
	
	static let extraLargeFont: CGFloat = 48
	static let largeFont: CGFloat = 24
	static let mediumFont: CGFloat = 20
	static let messageFont: CGFloat = 15
	static let smallFont: CGFloat = 13
	static let verySmallFont: CGFloat = 11
	
	// MARK: Spacing
	// reflect these spacing constants in UIEdgeInsetExtensions
	
	static let doubleExtraLarge: CGFloat = 48
	static let extraLarge: CGFloat = 24
	static let large: CGFloat = 16
	static let medium: CGFloat = 8
	static let small: CGFloat = 4
	static let verySmall: CGFloat = 2
	
	// MARK: Misc Constants
	
	static let screenHeight: CGFloat = UIScreen.main.bounds.height
	static let screenWidth: CGFloat = UIScreen.main.bounds.width
	static let iconWidth: CGFloat = 25
	static let borderWidth: CGFloat = 1.0 / UIScreen.main.scale
	static let one: CGFloat = 1
	static let zero: CGFloat = 0
}
