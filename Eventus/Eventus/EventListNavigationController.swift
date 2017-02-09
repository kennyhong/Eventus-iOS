//
//  EventListNavigationController.swift
//  Eventus
//
//  Created by Kieran on 2017-02-08.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

class EventListNavigationController: UINavigationController {
	
	init() {
		super.init(nibName: nil, bundle: nil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		let eventListViewController = EventListViewController()
		navigationBar.isTranslucent = false
		viewControllers = [eventListViewController]
	}
}
