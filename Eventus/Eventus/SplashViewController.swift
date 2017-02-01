//
//  SplashViewController.swift
//  Eventus
//
//  Created by Kieran on 2017-01-30.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
	
	init() {
		super.init(nibName: nil, bundle: nil)
		setupChildViewController()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	fileprivate func setupChildViewController() {
		User.shared.populateDefaults()
		if User.shared.isLoggedIn == nil || !User.shared.isLoggedIn! {
			let loginViewController = LoginViewController()
			loginViewController.delegate = self
			addChildViewController(loginViewController)
			view.addSubviewForAutolayout(loginViewController.view)
			loginViewController.view.constrainToFillView(view)
		} else {
			let eventListViewController = EventListViewController()
			addChildViewController(eventListViewController)
			view.addSubviewForAutolayout(eventListViewController.view)
			eventListViewController.view.constrainToFillView(view)
		}
	}
}

extension SplashViewController: LoginViewControllerDelegate {
	
	func didAuthenicateLogin() {
		setupChildViewController()
	}
}
