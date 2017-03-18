import UIKit

class EventInvoiceViewController: UIViewController {
	
	fileprivate var currentEvent = Event()
	fileprivate let serviceList = TwoColumnListView()
	fileprivate let separator = HorizontalSeparator()
	fileprivate let totalsList = TwoColumnListView()
	
	init(withEvent event: Event) {
		currentEvent = event
		super.init(nibName: nil, bundle: nil)
		setup()
		setupServiceList()
		setupSeparatorLine()
		setupTotalsList()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		view.backgroundColor = .white
		title = "Event Invoice"
	}
	
	private func setupServiceList() {
		view.addSubviewForAutolayout(serviceList)
		serviceList.constrainToFillViewHorizontally(view)
		serviceList.pinInsideTopOf(view: view)
		
		serviceList.addRowWith(leftColumnString: "Service", rightColumnString: "Cost", withAttributes: underlineAttribute)
		for service in currentEvent.services {
			serviceList.addRowWith(leftColumnString: service.name!, rightColumnString: "$\(service.cost!)")
		}
	}
	
	private func setupSeparatorLine() {
		view.addSubviewForAutolayout(separator)
		separator.pinToBottomOfView(view: serviceList, constant: .medium)
		separator.constrainToFillViewHorizontally(view, withMargins: .medium)
	}
	
	private func setupTotalsList() {
		view.addSubviewForAutolayout(totalsList)
		totalsList.constrainToFillViewHorizontally(view)
		totalsList.pinToBottomOfView(view: separator, constant: .medium)
		
		totalsList.addRowWith(leftColumnString: "Subtotal", rightColumnString: "$\(currentEvent.subTotal!)")
		totalsList.addRowWith(leftColumnString: "Tax", rightColumnString: "$\(currentEvent.tax!)")
		totalsList.addRowWith(leftColumnString: "Total", rightColumnString: "$\(currentEvent.total!)", withAttributes: boldAttribute)
	}
}
