import UIKit

extension UIViewController {
	
	func request(withString requestString: String, requestType type: String, json: [String: Any]? = nil, completionHandler: @escaping ([String: Any]?) -> Void) {
		var request = URLRequest(url: URL(string: requestString)!)
		request.httpMethod = type
		if let json = json {
			do {
				request.httpBody = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
				request.addValue("application/json", forHTTPHeaderField: "Content-Type")
			} catch let error {
				print(error.localizedDescription)
			}
		}
		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				print("error=\(error)")
				return
			}
			
			if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
				print("Status code should be 200, but is \(httpStatus.statusCode)")
				print("response = \(response)")
			}
			
			let responseString = String(data: data, encoding: .utf8)
			completionHandler(self.jsonStringToDictionary(responseString!))
		}
		task.resume()
	}
	
	private func jsonStringToDictionary(_ json: String) -> [String: Any]? {
		if let data = json.data(using: .utf8) {
			do {
				return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
			} catch {
				print(error.localizedDescription)
			}
		}
		return nil
	}
}
