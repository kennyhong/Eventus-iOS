import UIKit

class PoweredByEventusView: UIView {
	
	fileprivate let label = UILabel()
	fileprivate let eventusLogoView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		setupLabel()
		setupEventusLogoView()
	}
	
	private func setupLabel() {
		label.text = "Powered by Eventus"
		label.textColor = .eventusGreen
		addSubviewForAutolayout(label)
		label.pinInsideLeftOf(view: self)
		label.constrainToFillViewVertically(self)
	}
	
	private func setupEventusLogoView() {
		eventusLogoView.image = #imageLiteral(resourceName: "iTunesArtwork")
		addSubviewForAutolayout(eventusLogoView)
		eventusLogoView.pinToRightOf(view: label)
		eventusLogoView.constrainToFillViewVertically(self)
		eventusLogoView.widthAnchor.constraint(equalToConstant: .footerHeight).isActive = true
		eventusLogoView.pinInsideRightOf(view: self)
	}
}
