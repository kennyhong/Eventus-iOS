//
//  ProfileNavigationController.swift
//  Eventus
//
//  Created by Kieran on 2017-02-08.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

protocol ProfileNavigationControllerDelegate {
	func shouldDestroyTabBarController()
}

class ProfileNavigationController: UINavigationController {
	
	var profileNavigationControllerDelegate: ProfileNavigationControllerDelegate?
	
	init() {
		super.init(nibName: nil, bundle: nil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		let profileViewController = ProfileViewController()
		profileViewController.delegate = self
		navigationBar.isTranslucent = false
		viewControllers = [profileViewController]
	}
}

extension ProfileNavigationController: ProfileViewControllerDelegate {
	
	func didTapLogoutUser() {
		profileNavigationControllerDelegate?.shouldDestroyTabBarController()
	}
}
