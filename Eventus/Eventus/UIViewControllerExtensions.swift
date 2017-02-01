//
//  UIViewControllerExtensions.swift
//  Eventus
//
//  Created by Kieran on 2017-02-01.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

extension UIViewController {
	
	func hideKeyboardWhenViewTapped() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
		view.addGestureRecognizer(tap)
	}
	
	@objc fileprivate func dismissKeyboard() {
		view.endEditing(true)
	}
	
	func removeViewControllerFromParent() {
		willMove(toParentViewController: nil)
		view.removeConstraints(view.constraints)
		view.removeFromSuperview()
		removeFromParentViewController()
	}
}
