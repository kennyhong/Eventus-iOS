import UIKit

protocol LoginViewControllerDelegate {
	func didAuthenicateLogin()
}

class LoginViewController: UIViewController {

	fileprivate let headerLabel = UILabel()
	fileprivate let usernameTextFieldWithButtonView = TextFieldWithButtonView()
	var delegate: LoginViewControllerDelegate?
	
	init() {
		super.init(nibName: nil, bundle: nil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		hideKeyboardWhenViewTapped()
		view.backgroundColor = .eventusGreen
		setupHeaderLabel()
		setupUsernameTextFieldWithButtonView()
	}
	
	private func setupHeaderLabel() {
		headerLabel.text = "Eventus"
		headerLabel.fontSize(of: .extraLargeFont)
		headerLabel.textColor = .white
		view.addSubviewForAutolayout(headerLabel)
		headerLabel.pinInsideTopOf(view: view, constant: .screenHeight / 3)
		headerLabel.constrainToBeCenteredInViewHorizontally(view)
	}
	
	private func setupUsernameTextFieldWithButtonView() {
		usernameTextFieldWithButtonView.delegate = self
		usernameTextFieldWithButtonView.buttonBackgroundColor = .white
		usernameTextFieldWithButtonView.buttonTitleColor = .eventusGreen
		usernameTextFieldWithButtonView.textFieldPlaceholder = "Username"
		view.addSubviewForAutolayout(usernameTextFieldWithButtonView)
		usernameTextFieldWithButtonView.constrainToBeCenteredInViewVertically(view)
		usernameTextFieldWithButtonView.constrainToFillViewHorizontally(view, withMargins: UIEdgeInsets(horizontal: .extraLarge))
	}
}

extension LoginViewController: TextFieldWithButtonViewDelegate {
	
	func didTriggerSubmit(withText text: String) {
		User.shared.username = text
		User.shared.isLoggedIn = true
		removeViewControllerFromParent()
		delegate?.didAuthenicateLogin()
	}
}
