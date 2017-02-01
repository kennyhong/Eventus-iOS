//
//  UILabelExtensions.swift
//  Eventus
//
//  Created by Kieran on 2017-02-01.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

extension UILabel {
	
	func fontSize(of sizeFont: CGFloat) {
		self.font = UIFont(name: self.font.fontName, size: sizeFont)!
		self.sizeToFit()
	}
}
