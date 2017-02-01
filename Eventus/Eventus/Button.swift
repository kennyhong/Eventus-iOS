//
//  Button.swift
//  Eventus
//
//  Created by Kieran on 2017-02-01.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

class Button: UIButton {
	
	fileprivate var shouldMakeParentTranslucentOnHighlight: Bool = false
	
	init(withMargins margins: UIEdgeInsets? = nil) {
		super.init(frame: .zero)
		guard let margins = margins else { return }
		contentEdgeInsets = margins
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var isHighlighted: Bool {
		didSet {
			if isHighlighted {
				if shouldMakeParentTranslucentOnHighlight {
					superview?.alpha = 0.65
				} else {
					alpha = 0.65
				}
			} else {
				if shouldMakeParentTranslucentOnHighlight {
					superview?.alpha = 1
				} else {
					alpha = 1
				}
			}
		}
	}
}
