import UIKit

class EventListViewController: UIViewController {
	
	fileprivate let tableView = UITableView()
	fileprivate var rowData: [Event] = []
	fileprivate let refreshControl = UIRefreshControl()
	fileprivate let dateFormatter = DateFormatter()
	
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
			let url = URL(string: "http://eventus.us-west-2.elasticbeanstalk.com/api/events/")
			let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
				do {
					if let data = data,
						let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
						let events = json["data"] as? [[String: Any]] {
						
						self.rowData = []
						for event in events {
							let services = event["services"] as! [[String : Any]]
							var allServices: [Service] = []
							for service in services {
								let serviceObject = Service(
									id: service["id"] as? Int,
									name: service["name"] as? String,
									cost: service["cost"] as? Double)
								allServices.append(serviceObject)
							}
							self.rowData.append(Event(
								id: event["id"] as? Int,
								name: event["name"] as? String,
								eventDescription: event["description"] as? String,
								date: self.dateFormatter.englishDate(from: event["date"] as? String),
								services: allServices)
							)
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
	
	@objc private func refresh() {
		queryList()
		refreshControl.endRefreshing()
	}
	
	@objc private func addEventTouched() {
		let createEventViewController = CreateEventViewController()
		createEventViewController.delegate = self
		let createEventNavigationController = UINavigationController(rootViewController: createEventViewController)
		createEventNavigationController.navigationBar.isTranslucent = false
		present(createEventNavigationController, animated: true, completion: nil)
	}
}

extension EventListViewController: EventPreviewViewDelegate {
	
	func didTouchEventPreviewView(withEvent event: Event) {
		let eventDetailsViewController = EventDetailsViewController(withEvent: event)
		eventDetailsViewController.delegate = self
		navigationController?.pushViewController(eventDetailsViewController, animated: true)
	}
}

extension EventListViewController: EventDetailsViewControllerDelegate {
	
	func didModifyEvent(event: Event) {
		let index = rowData.index(of: rowData.filter() { ($0 as Event).id == event.id! }.first!)
		rowData[index!] = event
		tableView.reloadData()
	}
	
	func didDeleteEvent(withId id: Int) {
		rowData = rowData.filter() { ($0 as Event).id != id }
		tableView.reloadData()
	}
}

extension EventListViewController: CreateEventViewControllerDelegate {
	
	func didCreateEvent(event: Event) {
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
		
		eventPreviewView?.event	= row
		return cell
	}
}

extension EventListViewController: UITableViewDataSource {
	
}
