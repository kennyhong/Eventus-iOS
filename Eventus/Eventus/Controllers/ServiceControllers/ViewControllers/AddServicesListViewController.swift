import UIKit

protocol AddServicesListViewControllerDelegate {
	func tableData(shouldUpdate: Bool)
}

class AddServicesListViewController: UIViewController {
	
	fileprivate let eventId: Int
	fileprivate let tableView = UITableView()
	fileprivate var rowData: [Service] = []
	fileprivate let refreshControl = UIRefreshControl()
	var delegate: AddServicesListViewControllerDelegate?
	
	init(withEventId id: Int) {
		eventId = id
		super.init(nibName: nil, bundle: nil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		view.backgroundColor = .white
		title = "Add Services"
		let doneBarItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(saveTouched))
		navigationItem.rightBarButtonItem = doneBarItem
		
		setupTableView()
		queryList()
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.rowHeight = 100.0
		tableView.allowsSelection = false
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddServicePreviewCell")
		
		view.addSubviewForAutolayout(tableView)
		tableView.constrainToFillView(view)
		
		refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
		tableView.addSubviewForAutolayout(refreshControl)
		refreshControl.heightAnchor.constraint(equalToConstant: 58).isActive = true
		refreshControl.constrainToBeCenteredInViewHorizontally(tableView)
		refreshControl.pinOnTopOfView(view: tableView)
	}
	
	private func queryList() {
		if isTesting {
			rowData.append(Service(id: 124, name: "test-add-service", cost: 100))
			tableView.reloadData()
		} else {
			let url = URL(string: "http://eventus.us-west-2.elasticbeanstalk.com/api/events/\(eventId)/services")
			let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
				do {
					if let data = data,
						let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
						let services = json["data"] as? [[String: Any]] {
						
						// TODO: remove this client side data manipulation when proper endpoint exists
						self.queryAllServices() {
							var currentlyAddedServiceIds: [Int] = []
							for service in services {
								currentlyAddedServiceIds.append(service["id"] as! Int)
							}
							for (i, service) in self.rowData.enumerated() {
								if currentlyAddedServiceIds.contains(service.id!) {
									self.rowData.remove(at: i)
								}
							}
							
							DispatchQueue.main.async(){
								self.tableView.reloadData()
							}
						}
					}
				} catch {
					print("Error deserializing JSON: \(error)")
				}
			}
			task.resume()
		}
	}
	
	private func queryAllServices(completionHandler: @escaping () -> Void) {
		let url = URL(string: "http://eventus.us-west-2.elasticbeanstalk.com/api/services")
		let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
			do {
				if let data = data,
					let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
					let services = json["data"] as? [[String: Any]] {
					
					self.rowData = []
					for service in services {
						self.rowData.append(Service(
							id: service["id"] as? Int,
							name: service["name"] as? String,
							cost: service["cost"] as? Int)
						);
						completionHandler()
					}
				}
			} catch {
				print("Error deserializing JSON: \(error)")
			}
		}
		task.resume()
	}
	
	@objc private func refresh() {
		queryList()
		refreshControl.endRefreshing()
	}
	
	@objc private func saveTouched() {
		delegate?.tableData(shouldUpdate: true)
		dismiss(animated: true, completion: nil)
	}
}

extension AddServicesListViewController: ServicePreviewViewDelegate {
	
	func didTouchServicePreviewView(withServiceId id: Int) {
		let serviceDetailsViewController = ServiceDetailsViewController(eventId: eventId, serviceId: id, isTiedToEvent: false)
		serviceDetailsViewController.delegate = self
		navigationController?.pushViewController(serviceDetailsViewController, animated: true)
	}
}

extension AddServicesListViewController: ServiceDetailsViewControllerDelegate {
	
	func didDeleteService(withId serviceId: Int) {
		
	}
	
	func didAddService(withId serviceId: Int) {
		for (i, service) in self.rowData.enumerated() {
			if service.id == serviceId {
				rowData.remove(at: i)
				break
			}
		}
		tableView.reloadData()
	}
}

extension AddServicesListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rowData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "AddServicePreviewCell", for: indexPath)
		let row = rowData[indexPath.row]
		
		let servicePreviewViewTag = 9101
		var servicePreviewView = cell.contentView.viewWithTag(servicePreviewViewTag) as? ServicePreviewView
		
		if servicePreviewView == nil {
			servicePreviewView = ServicePreviewView()
			servicePreviewView?.addBottomSeparator()
			servicePreviewView?.delegate = self
			
			if indexPath.row == 0 {
				servicePreviewView?.addTopSeparator()
			}
			
			cell.contentView.addSubviewForAutolayout(servicePreviewView!)
			servicePreviewView?.constrainToFillView(cell.contentView)
		}
		
		servicePreviewView?.id = row.id
		servicePreviewView?.name = row.name
		servicePreviewView?.cost = row.cost
		return cell
	}
}

extension AddServicesListViewController: UITableViewDataSource {
	
}
