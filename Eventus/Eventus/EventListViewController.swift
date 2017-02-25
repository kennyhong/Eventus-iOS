//
//  EventListViewController.swift
//  Eventus
//
//  Created by Kieran on 2017-02-01.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {
	
	internal let tableView = UITableView()
	internal var rowData: [Event] = []
	fileprivate let refreshControl = UIRefreshControl()
	
	init() {
		super.init(nibName: nil, bundle: nil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		title = "Events"
		
//		TODO: substitute stub data with event list API call
		let event1 = Event(name: "My Wedding", eventDescription: "test description")
		let event2 = Event(name: "My BBQ", eventDescription: "BBQ at my house", date: "1000-01-01 11:12:12")
		rowData.append(event1)
		rowData.append(event2)
		
		setupTableView()
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 175.0
		tableView.allowsSelection = false
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventPreviewCell")
		
		view.addSubviewForAutolayout(tableView)
		tableView.constrainToFillView(view)
		
		refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
		tableView.addSubviewForAutolayout(refreshControl)
		refreshControl.heightAnchor.constraint(equalToConstant: 58).isActive = true
		refreshControl.constrainToBeCenteredInViewHorizontally(tableView)
		refreshControl.pinOnTopOfView(view: tableView)
	}
	
	@objc private func refresh() {
//		TODO: query for new data on server before refreshing
		tableView.reloadData()
		refreshControl.endRefreshing()
	}
}

extension EventListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rowData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "EventPreviewCell\(indexPath.row)")
		
		if cell == nil {
			tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventPreviewCell\(indexPath.row)")
			cell = tableView.dequeueReusableCell(withIdentifier: "EventPreviewCell\(indexPath.row)")
			let row = rowData[indexPath.row]
			let eventPreviewView = EventPreviewView()
			eventPreviewView.name = row.name
			eventPreviewView.eventDescription = row.eventDescription
			eventPreviewView.date = row.date
			eventPreviewView.addBottomSeparator()
			if indexPath.row == 0 {
				eventPreviewView.addTopSeparator()
			}
			cell!.contentView.addSubviewForAutolayout(eventPreviewView)
			eventPreviewView.constrainToFillView(cell!.contentView)
		}
		
		return cell!
	}
}

extension EventListViewController: UITableViewDataSource {
	
}
