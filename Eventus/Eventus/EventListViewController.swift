//
//  EventListViewController.swift
//  Eventus
//
//  Created by Kieran on 2017-02-01.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		TODO: remove placeholder testing label
		let label = UILabel()
		view.addSubviewForAutolayout(label)
		label.text = "logged in as \(User.shared.username!)"
		label.constrainToBeCenteredInView(view)
	}
}
