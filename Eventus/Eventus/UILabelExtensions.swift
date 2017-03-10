import UIKit

extension UILabel {
	
	func fontSize(of sizeFont: CGFloat) {
		self.font = UIFont(name: self.font.fontName, size: sizeFont)!
		self.sizeToFit()
	}
}
