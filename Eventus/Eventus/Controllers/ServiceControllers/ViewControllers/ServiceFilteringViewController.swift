import UIKit

class ServiceFilteringViewController: UIViewController {
	
	fileprivate let serviceSortingLabel = UILabel()
	fileprivate let sortByNameButton = ButtonWithImageView()
	fileprivate let sortByCostButton = ButtonWithImageView()
	fileprivate let filterServicesLabel = UILabel()
	fileprivate let tableView = UITableView()
	fileprivate var rowData: [Tag] = []
	
	init() {
		super.init(nibName: nil, bundle: nil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		title = "Service Filtering"
		view.backgroundColor = .white
		
		setupServiceSortingLabel()
		setupSortByNameButton()
		setupSortByCostButton()
		setupFilterServicesLabel()
		setupTableView()
		queryList()
		
		updateSortStateImages()
	}
	
	private func setupServiceSortingLabel() {
		serviceSortingLabel.fontSize(of: .smallFont)
		serviceSortingLabel.text = "Service Sorting"
		serviceSortingLabel.textColor = .gray
		serviceSortingLabel.textAlignment = .left
		view.addSubviewForAutolayout(serviceSortingLabel)
		serviceSortingLabel.constrainToFillViewHorizontally(view, withMargins: UIEdgeInsets(left: .large))
		serviceSortingLabel.pinInsideTopOf(view: view, constant: .extraLarge)
	}
	
	private func setupSortByNameButton() {
		sortByNameButton.text = "Sort by Name"
		sortByNameButton.image = #imageLiteral(resourceName: "empty")
		sortByNameButton.backgroundColor = .white
		sortByNameButton.addTopSeparator()
		sortByNameButton.addBottomSeparator()
		sortByNameButton.delegate = self
		view.addSubviewForAutolayout(sortByNameButton)
		sortByNameButton.constrainToFillViewHorizontally(view)
		sortByNameButton.pinToBottomOfView(view: serviceSortingLabel, constant: .small)
	}
	
	private func setupSortByCostButton() {
		sortByCostButton.text = "Sort by Cost"
		sortByCostButton.image = #imageLiteral(resourceName: "empty")
		sortByCostButton.backgroundColor = .white
		sortByCostButton.addBottomSeparator()
		sortByCostButton.delegate = self
		view.addSubviewForAutolayout(sortByCostButton)
		sortByCostButton.constrainToFillViewHorizontally(view)
		sortByCostButton.pinToBottomOfView(view: sortByNameButton)
	}
	
	private func setupFilterServicesLabel() {
		filterServicesLabel.fontSize(of: .smallFont)
		filterServicesLabel.text = "Filter Services"
		filterServicesLabel.textColor = .gray
		filterServicesLabel.textAlignment = .left
		view.addSubviewForAutolayout(filterServicesLabel)
		filterServicesLabel.constrainToFillViewHorizontally(view, withMargins: UIEdgeInsets(left: .large))
		filterServicesLabel.pinToBottomOfView(view: sortByCostButton, constant: .extraLarge)
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.separatorStyle = .none
		tableView.rowHeight = 50.0
		tableView.allowsSelection = false
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ServiceFilteringPreviewCell")
		
		view.addSubviewForAutolayout(tableView)
		tableView.constrainToFillViewHorizontally(view)
		tableView.pinToBottomOfView(view: filterServicesLabel, constant: .small)
		tableView.pinInsideBottomOf(view: view)
	}
	
	fileprivate func queryList() {
		if isTesting {
			let t1 = Tag(id: 1, tag: "test-tag-1")
			let t2 = Tag(id: 2, tag: "test-tag-2")
			rowData = [t1, t2]
			tableView.reloadData()
		} else {
			let url = URL(string: "http://eventus.us-west-2.elasticbeanstalk.com/api/service_tags")
			let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
				do {
					if let data = data,
						let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
						let tags = json["data"] as? [[String: Any]] {
						
						self.rowData = []
						for tag in tags {
							let isSelected = ServiceFilteringSettings.shared.selectedTags.contains(where: {$0.id == (tag["id"] as? Int)})
							self.rowData.append(Tag(
								id: tag["id"] as? Int,
								tag: tag["name"] as? String,
								isSelected: isSelected)
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
	
	fileprivate func updateSortStateImages() {
		switch ServiceFilteringSettings.shared.sortState {
			case .nameAscending:
				sortByNameButton.image = #imageLiteral(resourceName: "up-chevron")
				sortByCostButton.image = #imageLiteral(resourceName: "empty")
			case .nameDescending:
				sortByNameButton.image = #imageLiteral(resourceName: "down-chevron")
				sortByCostButton.image = #imageLiteral(resourceName: "empty")
			case .costAscending:
				sortByNameButton.image = #imageLiteral(resourceName: "empty")
				sortByCostButton.image = #imageLiteral(resourceName: "up-chevron")
			case .costDescending:
				sortByNameButton.image = #imageLiteral(resourceName: "empty")
				sortByCostButton.image = #imageLiteral(resourceName: "down-chevron")
		}
	}
}

extension ServiceFilteringViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return rowData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceFilteringPreviewCell", for: indexPath)
		let row = rowData[indexPath.row]
		
		let serviceFilterViewTag = 9101
		var serviceFilterView = cell.contentView.viewWithTag(serviceFilterViewTag) as? ButtonWithImageView
		
		if serviceFilterView == nil {
			serviceFilterView = ButtonWithImageView()
			serviceFilterView?.image = #imageLiteral(resourceName: "empty")
			serviceFilterView?.backgroundColor = .white
			serviceFilterView?.addBottomSeparator()
			serviceFilterView?.delegate = self
			
			if indexPath.row == 0 {
				serviceFilterView?.addTopSeparator()
			}
			
			cell.contentView.addSubviewForAutolayout(serviceFilterView!)
			serviceFilterView?.constrainToFillView(cell.contentView)
		}
		
		serviceFilterView?.text = row.tag
		serviceFilterView?.image = row.isSelected! ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "empty")
		return cell
	}
}

extension ServiceFilteringViewController: UITableViewDataSource {
	
}

extension ServiceFilteringViewController: ButtonWithImageViewDelegate {
	
	func didTapButton(sender: ButtonWithImageView) {
		switch sender {
			case sortByNameButton:
				ServiceFilteringSettings.shared.sortState = ServiceFilteringSettings.shared.sortState == .nameAscending ? .nameDescending : .nameAscending
			case sortByCostButton:
				ServiceFilteringSettings.shared.sortState = ServiceFilteringSettings.shared.sortState == .costAscending ? .costDescending : .costAscending
			default:
				let tagText = sender.text!
				if sender.image == #imageLiteral(resourceName: "check") {
					ServiceFilteringSettings.shared.selectedTags = ServiceFilteringSettings.shared.selectedTags.filter() { $0.tag != tagText }
					sender.image = #imageLiteral(resourceName: "empty")
					rowData.filter({$0.tag == tagText}).first!.isSelected = false
				} else {
					let tagId = rowData.filter({$0.tag == tagText}).first!.id
					ServiceFilteringSettings.shared.selectedTags.append(Tag(id: tagId, tag: tagText))
					sender.image = #imageLiteral(resourceName: "check")
					rowData.filter({$0.tag == tagText}).first!.isSelected = true
				}
		}
		updateSortStateImages()
	}
}
