//
//  EventListViewController.swift
//  Eventus
//
//  Created by Kieran on 2017-02-01.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {
	
	init() {
		super.init(nibName: nil, bundle: nil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		title = "Events"
		
//		TODO: remove placeholder testing label
		let label = UILabel()
		view.addSubviewForAutolayout(label)
		label.text = "logged in as \(User.shared.username!)"
		label.constrainToBeCenteredInView(view)
		
//		TODO: parse and use in table
		let url = URL(string: "http://sample-env-1.ypg3tzbv7e.us-west-2.elasticbeanstalk.com/api/events")
		let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
			if let data = data,
				let html = String(data: data, encoding: String.Encoding.utf8) {
				print(html)
			}
		}
		task.resume()
	}
}
