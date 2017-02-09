//
//  User.swift
//  Eventus
//
//  Created by Kieran on 2017-02-01.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

class User {
	
	static let shared : User = {
		return User()
	}()
	
	var username: String? {
		didSet {
			UserDefaults.standard.set(username, forKey: "username")
		}
	}
	
	var isLoggedIn: Bool? {
		didSet {
			UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
		}
	}
	
	func populateDefaults() {
		username = UserDefaults.standard.value(forKey: "username") as? String
		isLoggedIn = UserDefaults.standard.value(forKey: "isLoggedIn") as? Bool
	}
}
