import UIKit

protocol AddServicesListViewControllerDelegate {
	func didAddService(_ service: Service)
}

class AddServicesListViewController: UIViewController {
	
	fileprivate let eventId: Int
	fileprivate let addedIdsString: String
	fileprivate let tableView = UITableView()
	fileprivate var rowData: [Service] = []
	fileprivate let refreshControl = UIRefreshControl()
	var delegate: AddServicesListViewControllerDelegate?
	
	private var urlString: String {
		get {
			if addedIdsString.isEmpty && ServiceFilteringSettings.shared.tagFilterString.isEmpty {
				return "http://eventus.us-west-2.elasticbeanstalk.com/api/services?\(ServiceFilteringSettings.shared.orderByString)"
			} else if addedIdsString.isEmpty && !ServiceFilteringSettings.shared.tagFilterString.isEmpty {
				return "http://eventus.us-west-2.elasticbeanstalk.com/api/services?\(ServiceFilteringSettings.shared.orderByString)&\(ServiceFilteringSettings.shared.tagFilterString)"
			} else if !addedIdsString.isEmpty && ServiceFilteringSettings.shared.tagFilterString.isEmpty {
				return "http://eventus.us-west-2.elasticbeanstalk.com/api/services?\(ServiceFilteringSettings.shared.orderByString)&\(addedIdsString)"
			} else if !addedIdsString.isEmpty && !ServiceFilteringSettings.shared.tagFilterString.isEmpty {
				return "http://eventus.us-west-2.elasticbeanstalk.com/api/services?\(ServiceFilteringSettings.shared.orderByString)&\(addedIdsString)&\(ServiceFilteringSettings.shared.tagFilterString)"
			}
			fatalError("Error: unknown state")
		}
	}
	
	init(withEventId id: Int, addedIdsString: String) {
		eventId = id
		self.addedIdsString = addedIdsString
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
			let oldRowData = rowData
			let s1 = Service(id: 1, name: "test-add-service", cost: 100.0)
			let s2 = Service(id: 2, name: "test-add-service2", cost: 50.0)
			let s3 = Service(id: 3, name: "test-add-service3", cost: 150.0)
			switch ServiceFilteringSettings.shared.sortState {
				case .nameAscending:
					rowData = [s1, s2, s3]
				case .nameDescending:
					rowData = [s3, s2, s1]
				case .costAscending:
					rowData = [s2, s1, s3]
				case .costDescending:
					rowData = [s3, s1, s2]
			}
			if ServiceFilteringSettings.shared.selectedTags.count > 0 {
				var validServices: [Service] = []
				for tagID in ServiceFilteringSettings.shared.selectedTags {
					validServices.append(contentsOf: rowData.filter() { ($0 as Service).id! == tagID.id! })
				}
				rowData = validServices
			}
			if oldRowData.count > 0 {
				for element in rowData {
					if !oldRowData.contains(element) {
						rowData = rowData.filter() { $0 != element }
					}
				}
			}
			tableView.reloadData()
		} else {
			let url = URL(string: urlString)
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
	
	@objc private func saveTouched() {
		dismiss(animated: true, completion: nil)
	}
}

extension AddServicesListViewController: ServicePreviewViewDelegate {
	
	func didTouchServicePreviewView(withService service: Service) {
		let serviceDetailsViewController = ServiceDetailsViewController(eventId: eventId, service: service, isTiedToEvent: false)
		serviceDetailsViewController.delegate = self
		navigationController?.pushViewController(serviceDetailsViewController, animated: true)
	}
}

extension AddServicesListViewController: ServiceDetailsViewControllerDelegate {
	
	func didDeleteService(withId serviceId: Int) {
		
	}
	
	func didAddService(_ service: Service) {
		rowData = rowData.filter() { ($0 as Service).id != service.id! }
		tableView.reloadData()
		delegate?.didAddService(service)
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
