//
//  UIViewExtensions.swift
//  Eventus
//
//  Created by Kieran on 2017-01-27.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

public extension UIView {
	
	func addSubviewForAutolayout(_ view: UIView) {
		view.translatesAutoresizingMaskIntoConstraints = false
		addSubview(view)
	}
	
	func addSubviewsForAutolayout(_ views: UIView...) {
		views.forEach { view in
			view.translatesAutoresizingMaskIntoConstraints = false
			addSubview(view)
		}
	}
	
	func constrainToFillViewHorizontally(_ view: UIView, withMargins insets: UIEdgeInsets = .zero) {
		NSLayoutConstraint.activate([
			leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
			trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right)
		])
	}
	
	func constrainToFillViewVertically(_ view: UIView, withMargins insets: UIEdgeInsets = .zero) {
		NSLayoutConstraint.activate([
			topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
			bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
		])
	}
	
	func constrainToFillView(_ view: UIView, withMargins insets: UIEdgeInsets = .zero) {
		NSLayoutConstraint.activate([
			leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
			topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
			bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
			trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
		])
	}
	
	func constrainToBeCenteredInView(_ view: UIView) {
		constrainToBeCenteredInViewVertically(view)
		constrainToBeCenteredInViewHorizontally(view)
	}
	
	func constrainToBeCenteredInViewHorizontally(_ view: UIView, constant: CGFloat = 0) {
		NSLayoutConstraint.activate([
			centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant)
		])
	}
	
	func constrainToBeCenteredInViewVertically(_ view: UIView, constant: CGFloat = 0) {
		NSLayoutConstraint.activate([
			centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant)
		])
	}
	
	func pinInsideTopOf(view: UIView, constant: CGFloat = 0) {
		NSLayoutConstraint.activate([
			topAnchor.constraint(equalTo: view.topAnchor, constant: constant)
		])
	}
	
	func pinToBottomOfView(view: UIView, constant: CGFloat = 0) {
		NSLayoutConstraint.activate([
			topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
		])
	}
	
	func pinInsideBottomOf(view: UIView, constant: CGFloat = 0) {
		NSLayoutConstraint.activate([
			bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
		])
	}
	
	func pinOnTopOfView(view: UIView, constant: CGFloat = 0) {
		NSLayoutConstraint.activate([
			bottomAnchor.constraint(equalTo: view.topAnchor, constant: constant)
		])
	}
	
	func pinToLeftOf(view: UIView, constant: CGFloat = 0) {
		NSLayoutConstraint.activate([
			rightAnchor.constraint(equalTo: view.leftAnchor, constant: constant)
		])
	}
	
	func pinInsideLeftOf(view: UIView, constant: CGFloat = 0) {
		NSLayoutConstraint.activate([
			leftAnchor.constraint(equalTo: view.leftAnchor, constant: constant)
		])
	}
	
	func pinToRightOf(view: UIView, constant: CGFloat = 0) {
		NSLayoutConstraint.activate([
			leftAnchor.constraint(equalTo: view.rightAnchor, constant: constant)
		])
	}
	
	func pinInsideRightOf(view: UIView, constant: CGFloat = 0) {
		NSLayoutConstraint.activate([
			rightAnchor.constraint(equalTo: view.rightAnchor, constant: -constant)
		])
	}
	
	func addTopSeparator(inside: Bool = true) {
		let separator = HorizontalSeparator()
		addSubviewForAutolayout(separator)
		if inside {
			separator.pinInsideTopOf(view: self)
		} else {
			separator.pinOnTopOfView(view: self)
		}
		separator.constrainToFillViewHorizontally(self)
	}
	
	func addBottomSeparator(inside: Bool = true) {
		let separator = HorizontalSeparator()
		addSubviewForAutolayout(separator)
		if inside {
			separator.pinInsideBottomOf(view: self)
		} else {
			separator.pinToBottomOfView(view: self)
		}
		separator.constrainToFillViewHorizontally(self)
	}
	
	func addLeftSeparator() {
		let separator = VerticalSeparator()
		addSubviewForAutolayout(separator)
		NSLayoutConstraint.activate([
			separator.leadingAnchor.constraint(equalTo: leadingAnchor)
		])
		separator.constrainToFillViewVertically(self)
	}
	
	func addRightSeparator() {
		let separator = VerticalSeparator()
		addSubviewForAutolayout(separator)
		NSLayoutConstraint.activate([
			separator.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
		separator.constrainToFillViewVertically(self)
	}
}
