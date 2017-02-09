//
//  MainTabBarController.swift
//  Eventus
//
//  Created by Kieran on 2017-02-08.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

protocol MainTabBarControllerDelegate {
	func didLogoutSession()
}

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
	
	var logoutDelegate: MainTabBarControllerDelegate?
	
	init() {
		super.init(nibName: nil, bundle: nil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		self.delegate = self
		
		tabBar.isTranslucent = false
		
		let eventListNavigationController = EventListNavigationController()
		let eventListBarItem = UITabBarItem(title: nil, image: UIImage(named: "calendar"), selectedImage: UIImage(named: "calendar"))
		eventListNavigationController.tabBarItem = eventListBarItem
		eventListNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: .small + .verySmall, left: .small, bottom: -.small - .verySmall, right: -.small)
		
		let profileNavigationController = ProfileNavigationController()
		profileNavigationController.profileNavigationControllerDelegate = self
		let profileBarItem = UITabBarItem(title: nil, image: UIImage(named: "profile"), selectedImage: UIImage(named: "profile"))
		profileNavigationController.tabBarItem = profileBarItem
		profileNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: .small + .verySmall, left: .small, bottom: -.small - .verySmall, right: -.small)
		
		self.viewControllers = [eventListNavigationController, profileNavigationController]
	}
}

extension MainTabBarController: ProfileNavigationControllerDelegate {
	
	func shouldDestroyTabBarController() {
		if let vcs = self.viewControllers {
			for vc in vcs {
				vc.removeViewControllerFromParent()
			}
		}
		logoutDelegate?.didLogoutSession()
	}
}
