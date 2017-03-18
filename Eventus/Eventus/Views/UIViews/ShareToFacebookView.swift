import UIKit

class ShareToFacebookView: UIView {
	
	fileprivate let stackView = UIStackView(axis: .vertical, spacing: .verySmall)
	fileprivate let qrCodeImageView = UIImageView()
	fileprivate let footerContainerView = UIView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var qrCodeImage: CIImage? {
		didSet {
			guard let qrCodeImage = qrCodeImage else { return }
			qrCodeImageView.image = UIImage(ciImage: qrCodeImage)
		}
	}
	
	private func setup() {
		setupQrCodeImageView()
		setupFooterContainerView()
	}
	
	private func setupQrCodeImageView() {
		qrCodeImageView.backgroundColor = .red
		addSubviewForAutolayout(qrCodeImageView)
		qrCodeImageView.constrainToFillViewHorizontally(self, withMargins: UIEdgeInsets(horizontal: (.footerHeight / 2) + (.large / 2)))
		qrCodeImageView.pinInsideTopOf(view: self, constant: .large)
		qrCodeImageView.pinInsideBottomOf(view: self, constant: .footerHeight)
	}
	
	private func setupFooterContainerView() {
		addSubviewForAutolayout(footerContainerView)
		footerContainerView.constrainToFillViewHorizontally(self)
		footerContainerView.pinInsideBottomOf(view: self)
		footerContainerView.heightAnchor.constraint(equalToConstant: .footerHeight).isActive = true
		
		let poweredByEventusView = PoweredByEventusView()
		footerContainerView.addSubviewForAutolayout(poweredByEventusView)
		poweredByEventusView.constrainToFillViewVertically(footerContainerView)
		poweredByEventusView.constrainToBeCenteredInViewHorizontally(footerContainerView, constant: .small)
	}
}
