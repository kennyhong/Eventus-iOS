//
//  HorizontalSeparator.swift
//  Eventus
//
//  Created by Kieran on 2017-01-27.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

public class HorizontalSeparator: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .lightGray
	}
	
	public override var intrinsicContentSize : CGSize {
		return CGSize(width: UIViewNoIntrinsicMetric, height: .borderWidth)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func setColor(_ color: UIColor) {
		backgroundColor = color
	}
}
