import UIKit

protocol ServiceDetailsViewControllerDelegate {
	func didDeleteService(withId serviceId: Int)
	func didAddService(_ service: Service)
}

class ServiceDetailsViewController: UIViewController {
	
	fileprivate let eventId: Int
	fileprivate let service: Service
	fileprivate let isTiedToEvent: Bool
	fileprivate let addServiceButton = Button(withMargins: UIEdgeInsets(horizontal: .large, vertical: .medium + .small))
	fileprivate let deleteServiceButton = Button(withMargins: UIEdgeInsets(horizontal: .large, vertical: .medium + .small))
	var delegate: ServiceDetailsViewControllerDelegate?
	
	init(eventId eID: Int, service: Service, isTiedToEvent: Bool) {
		eventId = eID
		self.service = service
		self.isTiedToEvent = isTiedToEvent
		super.init(nibName: nil, bundle: nil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		view.backgroundColor = .white
		title = "Service Details"
		
		isTiedToEvent ? setupDeleteServiceButton() : setupAddServiceButton()
	}
	
	private func setupAddServiceButton() {
		addServiceButton.setTitle("Add Service", for: .normal)
		addServiceButton.setTitleColor(.accept, for: .normal)
		addServiceButton.titleLabel?.textAlignment = .center
		addServiceButton.addTarget(self, action: #selector(didTapAddService), for: .touchUpInside)
		addServiceButton.addTopSeparator()
		addServiceButton.addBottomSeparator()
		view.addSubviewForAutolayout(addServiceButton)
		addServiceButton.constrainToBeCenteredInView(view)
		addServiceButton.constrainToFillViewHorizontally(view)
	}
	
	private func setupDeleteServiceButton() {
		deleteServiceButton.setTitle("Delete Service", for: .normal)
		deleteServiceButton.setTitleColor(.cancel, for: .normal)
		deleteServiceButton.titleLabel?.textAlignment = .center
		deleteServiceButton.addTarget(self, action: #selector(didTapDeleteService), for: .touchUpInside)
		deleteServiceButton.addTopSeparator()
		deleteServiceButton.addBottomSeparator()
		view.addSubviewForAutolayout(deleteServiceButton)
		deleteServiceButton.constrainToBeCenteredInView(view)
		deleteServiceButton.constrainToFillViewHorizontally(view)
	}
	
	@objc private func didTapAddService() {
		if !isTesting {
			request(withString: "http://eventus.us-west-2.elasticbeanstalk.com/api/events/\(self.eventId)/services/\(self.service.id!)", requestType: "POST") { response in
				
				print("response = \(String(describing: response))")
			}
		}
		self.delegate?.didAddService(service)
		_ = self.navigationController?.popViewController(animated: true)
	}
	
	@objc private func didTapDeleteService() {
		let alertController = UIAlertController(title: "Remove Service", message: "Are you sure you want to remove this service?", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (alert: UIAlertAction) -> Void in
			if !isTesting {
				self.request(withString: "http://eventus.us-west-2.elasticbeanstalk.com/api/events/\(self.eventId)/services/\(self.service.id!)", requestType: "DELETE") { response in
					
					print("response = \(String(describing: response))")
				}
			}
			self.dismiss(animated: true, completion: nil)
			self.delegate?.didDeleteService(withId: self.service.id!)
			_ = self.navigationController?.popViewController(animated: true)
		}))
		alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
		present(alertController, animated: true, completion: nil)
	}
}
