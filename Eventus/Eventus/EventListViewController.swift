//
//  EventListViewController.swift
//  Eventus
//
//  Created by Kieran on 2017-02-01.
//  Copyright © 2017 Kieran Cairney. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController {
	
	fileprivate let tableView = UITableView()
	fileprivate var rowData: [Event] = []
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

		let addEventButton = Button()
		addEventButton.setIconImage(#imageLiteral(resourceName: "plus"), withColor: .white)
		addEventButton.addTarget(self, action: #selector(addEventTouched), for: .touchUpInside)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addEventButton)
		
		self.setupTableView()
		queryList()
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.rowHeight = 150.0
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
	
	private func queryList() {
		if !isTesting {
			let url = URL(string: "http://eventus.us-west-2.elasticbeanstalk.com/api/events")
			let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
				do {
					if let data = data,
						let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
						let events = json["data"] as? [[String: Any]] {
						
						self.rowData = []
						for event in events {
							self.rowData.append(Event(
								id: event["id"] as? Int,
								name: event["name"] as? String,
								eventDescription: event["description"] as? String,
								date: event["date"] as? String)
							);
						}
						DispatchQueue.main.async(){
							self.tableView.reloadData()
						}
					}
				} catch {
					print("Error deserializing JSON: \(error)")
				}
			}
			task.resume()
		}
	}
	
	func populateTestingRowData(withEvents events: [Event]) {
		if isTesting {
			rowData = []
			for event in events {
				rowData.append(event)
			}
			self.tableView.reloadData()
		}
	}
	
	@objc private func refresh() {
		queryList()
		refreshControl.endRefreshing()
	}
	
	@objc private func addEventTouched() {
		let addEventViewController = AddEventViewController()
		addEventViewController.delegate = self
		let addEventNavigationController = UINavigationController(rootViewController: addEventViewController)
		addEventNavigationController.navigationBar.isTranslucent = false
		present(addEventNavigationController, animated: true, completion: nil)
	}
}

extension EventListViewController: EventPreviewViewDelegate {
	
	func didTouchEventPreviewView(withEventId id: Int) {
		let eventDetailsViewController = EventDetailsViewController(withEventId: id)
		eventDetailsViewController.delegate = self
		navigationController?.pushViewController(eventDetailsViewController, animated: true)
	}
}

extension EventListViewController: EventDetailsViewControllerDelegate {
	
	func didDeleteEvent(withId id: Int) {
		for (i, event) in rowData.enumerated() {
			if event.id == id {
				rowData.remove(at: i)
				break
			}
		}
		tableView.reloadData()
	}
}

extension EventListViewController: AddEventViewControllerDelegate {
	
	func didAddEvent(event: Event) {
		rowData.append(event)
		tableView.reloadData()
	}
}

extension EventListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rowData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "EventPreviewCell", for: indexPath)
		let row = rowData[indexPath.row]
		
		let eventPreviewViewTag = 6281
		var eventPreviewView = cell.contentView.viewWithTag(eventPreviewViewTag) as? EventPreviewView
		
		if eventPreviewView == nil {
			eventPreviewView = EventPreviewView()
			eventPreviewView?.addBottomSeparator()
			eventPreviewView?.delegate = self
			
			if indexPath.row == 0 {
				eventPreviewView?.addTopSeparator()
			}
			
			cell.contentView.addSubviewForAutolayout(eventPreviewView!)
			eventPreviewView?.constrainToFillView(cell.contentView)
		}
		
		eventPreviewView?.id = row.id
		eventPreviewView?.name = row.name
		eventPreviewView?.eventDescription = row.eventDescription
		eventPreviewView?.date = row.date
		return cell
	}
}

extension EventListViewController: UITableViewDataSource {
	
}
