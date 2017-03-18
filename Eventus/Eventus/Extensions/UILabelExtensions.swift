import UIKit

extension UILabel {
	
	func fontSize(of sizeFont: CGFloat) {
		self.font = UIFont(name: self.font.fontName, size: sizeFont)!
		self.sizeToFit()
	}
	
	func setAttributes(_ attributes: [String : Any]?) {
		guard let text = text, attributes != nil else { return }
		let textRange = NSMakeRange(0, text.characters.count)
		let attributedText = NSMutableAttributedString(string: text)
		attributedText.addAttributes(attributes!, range: textRange)
		self.attributedText = attributedText
	}
}
