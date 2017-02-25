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
			UserDefaults(suiteName: "group.eventus")!.set(username, forKey: "username")
			UserDefaults(suiteName: "group.eventus")!.synchronize()
		}
	}
	
	var isLoggedIn: Bool? {
		didSet {
			UserDefaults(suiteName: "group.eventus")!.set(isLoggedIn, forKey: "isLoggedIn")
			UserDefaults(suiteName: "group.eventus")!.synchronize()
		}
	}
	
	func populateDefaults() {
		username = UserDefaults(suiteName: "group.eventus")!.value(forKey: "username") as? String
		isLoggedIn = UserDefaults(suiteName: "group.eventus")!.value(forKey: "isLoggedIn") as? Bool
	}
}
