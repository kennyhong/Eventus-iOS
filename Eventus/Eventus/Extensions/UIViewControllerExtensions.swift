import UIKit

extension UIViewController {
	
	func hideKeyboardWhenViewTapped() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
		view.addGestureRecognizer(tap)
	}
	
	@objc fileprivate func dismissKeyboard() {
		view.endEditing(true)
	}
	
	func removeViewControllerFromParent() {
		willMove(toParentViewController: nil)
		view.removeConstraints(view.constraints)
		view.removeFromSuperview()
		removeFromParentViewController()
	}
}
