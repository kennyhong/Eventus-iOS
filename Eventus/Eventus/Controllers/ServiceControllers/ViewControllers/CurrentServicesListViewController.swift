import UIKit

protocol CurrentServicesListViewControllerDelegate {
	func didAddService(_ service: Service)
	func didDeleteService(withId id: Int)
}

class CurrentServicesListViewController: UIViewController {
	
	fileprivate let eventId: Int
	fileprivate let tableView = UITableView()
	fileprivate var rowData: [Service] = []
	fileprivate let refreshControl = UIRefreshControl()
	var delegate: CurrentServicesListViewControllerDelegate?
	
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
		title = "Current Services"
		
		let addServiceButton = Button()
		addServiceButton.setIconImage(#imageLiteral(resourceName: "plus"), withColor: .white)
		addServiceButton.addTarget(self, action: #selector(addServiceTouched), for: .touchUpInside)
		navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addServiceButton)
		
		setupTableView()
		queryList()
	}
	
	fileprivate func queryList() {
		if isTesting {
			tableView.reloadData()
		} else {
			let url = URL(string: "http://eventus.us-west-2.elasticbeanstalk.com/api/events/\(eventId)/services")
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
								cost: service["cost"] as? Double)
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
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.rowHeight = 100.0
		tableView.allowsSelection = false
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CurrentServicePreviewCell")
		
		view.addSubviewForAutolayout(tableView)
		tableView.constrainToFillView(view)
		
		refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
		tableView.addSubviewForAutolayout(refreshControl)
		refreshControl.heightAnchor.constraint(equalToConstant: 58).isActive = true
		refreshControl.constrainToBeCenteredInViewHorizontally(tableView)
		refreshControl.pinOnTopOfView(view: tableView)
	}
	
	@objc private func refresh() {
		queryList()
		refreshControl.endRefreshing()
	}
	
	@objc private func addServiceTouched() {
		let addServiceListViewController = AddServicesListViewController(withEventId: eventId)
		addServiceListViewController.delegate = self
		let addServicesNavigationController = UINavigationController(rootViewController: addServiceListViewController)
		addServicesNavigationController.navigationBar.isTranslucent = false
		present(addServicesNavigationController, animated: true, completion: nil)
	}
}

extension CurrentServicesListViewController: ServicePreviewViewDelegate {
	
	func didTouchServicePreviewView(withService service: Service) {
		let serviceDetailsViewController = ServiceDetailsViewController(eventId: eventId, service: service, isTiedToEvent: true)
		serviceDetailsViewController.delegate = self
		navigationController?.pushViewController(serviceDetailsViewController, animated: true)
	}
}

extension CurrentServicesListViewController: ServiceDetailsViewControllerDelegate {
	
	func didDeleteService(withId serviceId: Int) {
		rowData = rowData.filter() { ($0 as Service).id != serviceId }
		delegate?.didDeleteService(withId: serviceId)
		tableView.reloadData()
	}
}

extension CurrentServicesListViewController: AddServicesListViewControllerDelegate {
	
	func didAddService(_ service: Service) {
		rowData.append(service)
		delegate?.didAddService(service)
		tableView.reloadData()
	}
}

extension CurrentServicesListViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rowData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentServicePreviewCell", for: indexPath)
		let row = rowData[indexPath.row]
		
		let servicePreviewViewTag = 5439
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

extension CurrentServicesListViewController: UITableViewDataSource {
	
}
