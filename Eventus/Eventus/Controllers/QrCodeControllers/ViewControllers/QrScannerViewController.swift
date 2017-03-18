import AVFoundation
import UIKit
import EventKit

class QrScannerViewController: UIViewController {
	
	fileprivate var captureSession: AVCaptureSession?
	fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
	fileprivate var qrCodeFrameView: UIView?
	fileprivate let dateFormatter = DateFormatter()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Event Scanner"
		
		do {
			let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
			let input = try AVCaptureDeviceInput(device: captureDevice)
			
			captureSession = AVCaptureSession()
			captureSession?.addInput(input as AVCaptureInput)
			
			let captureMetadataOutput = AVCaptureMetadataOutput()
			captureSession?.addOutput(captureMetadataOutput)
			
			captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
			
			videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
			videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
			videoPreviewLayer?.frame = view.layer.bounds
			view.layer.addSublayer(videoPreviewLayer!)
			
			captureSession?.startRunning()
			
			qrCodeFrameView = UIView()
			qrCodeFrameView?.layer.borderColor = UIColor.eventusGreen.cgColor
			qrCodeFrameView?.layer.borderWidth = 5
			view.addSubview(qrCodeFrameView!)
			view.bringSubview(toFront: qrCodeFrameView!)
		} catch let error as NSError {
			print("\(error.localizedDescription)")
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		qrCodeFrameView?.frame = .zero
		if (captureSession?.isRunning == false) {
			captureSession?.startRunning()
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if (captureSession?.isRunning == true) {
			captureSession?.stopRunning()
		}
	}
	
	fileprivate func handleCalendarPermissons(withResponseTokens response: [String]) {
		let eventStore = EKEventStore()
		switch EKEventStore.authorizationStatus(for: EKEntityType.event) {
		case .authorized:
			addEvent(store: eventStore, response: response)
		case .denied:
			let alertMessage = "Cannot add event to calendar due to permissions."
			let alertController = UIAlertController(title: "Permission Denied", message: alertMessage, preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { (alert: UIAlertAction) -> Void in
				
				_ = self.navigationController?.popViewController(animated: true)
			}))
			present(alertController, animated: true, completion: nil)
		case .notDetermined:
			eventStore.requestAccess(to: EKEntityType.event, completion: { (success: Bool, error: Error?) in
				if success {
					self.addEvent(store: eventStore, response: response)
				} else {
					let alertMessage = "\(error?.localizedDescription)"
					let alertController = UIAlertController(title: "Permission Denied", message: alertMessage, preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { (alert: UIAlertAction) -> Void in
						
						_ = self.navigationController?.popViewController(animated: true)
					}))
					self.present(alertController, animated: true, completion: nil)
				}
			})
		default:
			fatalError("Error: unknown switch state")
		}
	}
	
	private func addEvent(store: EKEventStore, response: [String]) {
		let event = EKEvent(eventStore : store)
		event.calendar = store.defaultCalendarForNewEvents
		event.title = response[0]
		event.notes = response[1]
		event.startDate = parsedDate(fromString: response[2])
		// TODO: add proper end date if time permits from server
		event.endDate = parsedDate(fromString: response[2], endHourOffset: 2)
		
		do {
			try store.save(event, span: .thisEvent)
			let alertMessage = "Successfully added event to calendar"
			let alertController = UIAlertController(title: "Success", message: alertMessage, preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (alert: UIAlertAction) -> Void in
				
				_ = self.navigationController?.popViewController(animated: true)
			}))
			present(alertController, animated: true, completion: nil)
		} catch let error as NSError {
			let alertMessage = error.localizedDescription
			let alertController = UIAlertController(title: "Add to Calendar Failure", message: alertMessage, preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { (alert: UIAlertAction) -> Void in
				
				_ = self.navigationController?.popViewController(animated: true)
			}))
			present(alertController, animated: true, completion: nil)
		}
	}
	
	private func parsedDate(fromString string: String, endHourOffset: Int? = 0) -> Date {
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let date = dateFormatter.date(from: string)!
		let calendar = Calendar.current
		return calendar.date(byAdding: .hour, value: endHourOffset!, to: date)!
	}
	
	fileprivate func handleResponse(_ response: String) {
		if !response.contains("http://eventus.us-west-2.elasticbeanstalk.com/api/events/") || Int(response.components(separatedBy: "/").last!) == nil {
			let alertMessage = "QR code cannot be translated into a calendar event"
			let alertController = UIAlertController(title: "Invalid QR Code", message: alertMessage, preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { (alert: UIAlertAction) -> Void in
				
				_ = self.navigationController?.popViewController(animated: true)
			}))
			present(alertController, animated: true, completion: nil)
		}
		let url = URL(string: response)
		let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
			do {
				if let data = data,
					let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
					let event = json["data"] as? [String : Any] {
					
					let name = event["name"] as! String
					let description = event["description"] as! String
					let date = (event["date"] as! String).components(separatedBy: " ").first!
					self.handleCalendarPermissons(withResponseTokens: [name, description, date])
				} else {
					let alertMessage = "Requested calendar event does not exist in the system"
					let alertController = UIAlertController(title: "Invalid QR Code", message: alertMessage, preferredStyle: .alert)
					alertController.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { (alert: UIAlertAction) -> Void in
						
						_ = self.navigationController?.popViewController(animated: true)
					}))
					self.present(alertController, animated: true, completion: nil)
				}
			} catch {
				print("Error deserializing JSON: \(error)")
			}
		}
		task.resume()
	}
}

extension QrScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
	
	func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
		if let metadataObject = metadataObjects.first {
			captureSession?.stopRunning()
			let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
			let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: readableObject)
			qrCodeFrameView?.frame = barCodeObject!.bounds
			if readableObject.stringValue != nil {
				AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
				handleResponse(readableObject.stringValue)
			}
		}
	}
}
