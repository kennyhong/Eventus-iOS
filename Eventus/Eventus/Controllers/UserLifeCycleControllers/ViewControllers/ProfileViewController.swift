import UIKit

protocol ProfileViewControllerDelegate {
	func didTapLogoutUser()
}

class ProfileViewController: UIViewController {
	
	fileprivate let scanEventButton = ButtonWithImageView()
	fileprivate let logoutButton = Button(withMargins: UIEdgeInsets(horizontal: .large, vertical: .medium + .small))
	var delegate: ProfileViewControllerDelegate?
	
	init() {
		super.init(nibName: nil, bundle: nil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		title = User.shared.username!
		
		setupScanEventButton()
		setupLogoutButton()
	}
	
	private func setupScanEventButton() {
		scanEventButton.text = "Scan QR Code Event"
		scanEventButton.image = #imageLiteral(resourceName: "right-chevron")
		scanEventButton.backgroundColor = .white
		scanEventButton.addTopSeparator()
		scanEventButton.addBottomSeparator()
		scanEventButton.delegate = self
		view.addSubviewForAutolayout(scanEventButton)
		scanEventButton.constrainToFillViewHorizontally(view)
		scanEventButton.pinInsideTopOf(view: view, constant: .extraLarge)
	}
	
	private func setupLogoutButton() {
		logoutButton.setTitle("Logout", for: .normal)
		logoutButton.setTitleColor(.cancel, for: .normal)
		logoutButton.titleLabel?.textAlignment = .center
		logoutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
		logoutButton.addTopSeparator()
		logoutButton.addBottomSeparator()
		view.addSubviewForAutolayout(logoutButton)
		logoutButton.constrainToFillViewHorizontally(view)
		logoutButton.pinInsideBottomOf(view: view, constant: .extraLarge)
	}
	
	@objc private func didTapLogout() {
		let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
		alertController.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (alert: UIAlertAction) -> Void in
			self.dismiss(animated: false, completion: nil)
			self.delegate?.didTapLogoutUser()
		}))
		alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
		present(alertController, animated: true, completion: nil)
	}
}

extension ProfileViewController: ButtonWithImageViewDelegate {
	
	func didTapButton(sender: ButtonWithImageView) {
		let viewController: UIViewController
		switch sender {
		case scanEventButton:
			viewController = QrScannerViewController()
		default:
			fatalError("unknown sender")
		}
		navigationController?.pushViewController(viewController, animated: true)
	}
}
