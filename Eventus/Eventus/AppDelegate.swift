//
//  AppDelegate.swift
//  Eventus
//
//  Created by Kieran on 2017-01-27.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		guard let window = window else { return false }
		let splashViewController = SplashViewController()
		window.rootViewController = splashViewController
		window.backgroundColor = .white
		window.makeKeyAndVisible()
		setupDefaultColors()
		return true
	}
	
	private func setupDefaultColors() {
		UIApplication.shared.statusBarStyle = .lightContent
		
		UITextField.appearance().tintColor = .eventusGreen
		UITextView.appearance().tintColor = .eventusGreen
		
		UINavigationBar.appearance().tintColor = .white
		UINavigationBar.appearance().barTintColor = .eventusGreen
		UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
		
		UITabBar.appearance().tintColor = .white
		UITabBar.appearance().barTintColor = .eventusGreen
		UITabBar.appearance().unselectedItemTintColor = .black
	}
}
