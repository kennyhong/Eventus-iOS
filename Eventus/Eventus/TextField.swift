import UIKit

class TextField: UITextField {
	
	fileprivate var padding = UIEdgeInsets()
	
	init(withPadding fieldPadding: UIEdgeInsets? = nil) {
		super.init(frame: .zero)
		if let fieldPadding = fieldPadding {
			padding = fieldPadding
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, padding)
	}
	
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, padding)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return UIEdgeInsetsInsetRect(bounds, padding)
	}
	
	func fontSize(of sizeFont: CGFloat) {
		self.font = UIFont(name: font!.fontName, size: sizeFont)!
	}
}
