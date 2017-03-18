import UIKit
import Social

class ShareEventOnFacebookViewController: UIViewController {
	
	fileprivate var currentEvent = Event()
	fileprivate let descriptionLabel = UILabel()
	fileprivate let shareToFacebookView = ShareToFacebookView()
	fileprivate var qrCodeImage: CIImage? = nil
	fileprivate let shareOnFacebookButton = Button(withMargins: UIEdgeInsets(horizontal: .large, vertical: .medium + .small))
	
	init(withEvent event: Event) {
		currentEvent = event
		super.init(nibName: nil, bundle: nil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setup() {
		view.backgroundColor = .white
		title = "Share Event on Facebook"
		
		setupDescriptionLabel()
		setupShareToFacebookView()
		setupShareOnFacebookButton()
	}
	
	private func setupDescriptionLabel() {
		descriptionLabel.numberOfLines = 0
		descriptionLabel.text = "Sharing on Facebook will post the below image, allowing Eventus users to scan the QR code to add your event to their iOS calendar"
		descriptionLabel.textAlignment = .center
		descriptionLabel.textColor = .eventusGreen
		view.addSubviewForAutolayout(descriptionLabel)
		descriptionLabel.pinInsideTopOf(view: view, constant: .large)
		descriptionLabel.constrainToFillViewHorizontally(view, withMargins: .large)
	}
	
	private func setupShareToFacebookView() {
		shareToFacebookView.qrCodeImage = generateQrCode()
		view.addSubviewForAutolayout(shareToFacebookView)
		shareToFacebookView.widthAnchor.constraint(equalToConstant: .screenWidth * 2 / 3).isActive = true
		shareToFacebookView.heightAnchor.constraint(equalToConstant: .screenWidth * 2 / 3).isActive = true
		shareToFacebookView.layer.borderColor = UIColor.lightGray.cgColor
		shareToFacebookView.layer.borderWidth = .borderWidth
		shareToFacebookView.pinToBottomOfView(view: descriptionLabel, constant: .large)
		shareToFacebookView.constrainToBeCenteredInViewHorizontally(view)
	}
	
	private func setupShareOnFacebookButton() {
		shareOnFacebookButton.backgroundColor = .facebookDeepBlue
		shareOnFacebookButton.setTitle("Share on Facebook", for: .normal)
		shareOnFacebookButton.setTitleColor(.white, for: .normal)
		shareOnFacebookButton.layer.cornerRadius = shareOnFacebookButton.intrinsicContentSize.height / 2
		shareOnFacebookButton.layer.masksToBounds = true
		shareOnFacebookButton.addTarget(self, action: #selector(didTapShareOnFacebookButton), for: .touchUpInside)
		view.addSubviewForAutolayout(shareOnFacebookButton)
		shareOnFacebookButton.pinToBottomOfView(view: shareToFacebookView, constant: .large)
		shareOnFacebookButton.constrainToBeCenteredInViewHorizontally(view)
	}
	
	private func generateQrCode() -> CIImage {
		let qrCodeString = "http://eventus.us-west-2.elasticbeanstalk.com/api/events/\(currentEvent.id!)"
		let data = qrCodeString.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
		let filter = CIFilter(name: "CIQRCodeGenerator")
		filter?.setValue(data, forKey: "inputMessage")
		filter?.setValue("Q", forKey: "inputCorrectionLevel")
		return filter!.outputImage!
	}
	
	@objc private func didTapShareOnFacebookButton() {
		if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook)) {
			let socialViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
			socialViewController.setInitialText("Scan this QR code with the Eventus® iOS app to add my event \"\(self.currentEvent.name!)\" on \(self.currentEvent.date!) to your calendar so you don't forget!")
			socialViewController.add(UIImage(view: shareToFacebookView))
			present(socialViewController, animated: true, completion: nil)
		} else {
			let alertMessage = "Please login to Facebook on your device."
			let alertController = UIAlertController(title: "No Account", message: alertMessage, preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { (alert: UIAlertAction) -> Void in
				
			}))
			present(alertController, animated: true, completion: nil)
		}
	}
}
