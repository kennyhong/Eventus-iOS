import UIKit

public class VerticalSeparator: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .lightGray
	}
	
	public override var intrinsicContentSize : CGSize {
		return CGSize(width: .borderWidth, height: UIViewNoIntrinsicMetric)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func setColor(_ color: UIColor) {
		backgroundColor = color
	}
}
