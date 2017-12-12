//
//  ViewController.swift
//  CS Rest Login
//
//  Created by gj3 on 12/10/17.
//  Copyright © 2017 gj3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	@IBOutlet weak var williamsBanner: UILabel!
	@IBOutlet weak var userID: UITextField!
	@IBOutlet weak var userPassword: UITextField!
	
	var is_SoapMessage: String = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cgs=\"http://pscsapp1-tst.williams.edu:13300/\"><soapenv:Header/><soapenv:Body><cgs:GetSystemStatus/></soapenv:Body></soapenv:Envelope>"
	var logMessage: String!
	var xmlRet: String?
	
	@IBAction func loginButton(_ sender: UIButton) {
		if (checkValuesFilled())
		{
			var rtStr: String
			rtStr = authenticateToPS(id: userID.text!, password: userPassword.text!)
			loginPop(top: "Whoopsie", msg: rtStr)
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		williamsBanner.text = "Williams"
		williamsBanner.font = UIFont(name: "ClarendonBT-Light", size: 50)
		//userPassword.text = "Crusher06"
		//userID.text = "W1683396"
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func checkValuesFilled() -> Bool {

		var missingLog = 0
		if (userID.text == "") {
			missingLog += 1
		}
		if (userPassword.text == "") {
			missingLog += 2
		}
		
		if (missingLog != 0)
		{
			switch missingLog {
			case 1: logMessage = "Please enter your user ID"
			case 2: logMessage = "Please enter your password"
			case 3: logMessage = "Please enter your user ID and Password"
			default: logMessage = "Something is wrong..."
			}
			
			loginPop(top:"Login Error", msg: logMessage!)
			
			return false
		}
		
		return true
	}
	
	//function to authenticate
	func authenticateToPS(id: String, password: String)  -> String{

		print("inside authenticateToPS")
		let is_URL: String = "http://pscsapp1-tst.williams.edu:13300/PSIGW/RESTListeningConnector/WMS_IOS_GET.v1/"
		print("is_URL is [" + is_URL + "]")
		let lobj_Request = NSMutableURLRequest(url: URL(string: is_URL)!)
		let session = URLSession.shared
		let err: NSError?
		var strRet: String = ""
		
		lobj_Request.httpMethod = "POST"
		lobj_Request.httpBody = is_SoapMessage.data(using: String.Encoding.utf8)
		lobj_Request.addValue("http://pscsapp1-tst.williams.edu:13300", forHTTPHeaderField: "Host")
		lobj_Request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
		lobj_Request.addValue(String(is_SoapMessage), forHTTPHeaderField: "Content-Length")
		//lobj_Request.addValue("223", forHTTPHeaderField: "Content-Length")
		lobj_Request.addValue("http://pscsapp1-tst.williams.edu:13300/PSIGW/RESTListeningConnector/WMS_IOS_GET.v1/", forHTTPHeaderField: "SOAPAction")
		
		let task = session.dataTask(with: lobj_Request as URLRequest, completionHandler: {data, response, err -> Void in
			print("Response: \(String(describing: response))")
			let strData = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
			if (strData != nil){
				print("Body: \(String(describing: strData))")

				strRet = String(describing: strData)
				print("GREGG : " + strRet)
				
				//XMLParser.init(data: strData)
			}
			else
			{
				print("GREGG: HERE")
			}
			if err != nil
			{
				print("Error: " + err!.localizedDescription)
			}
			
		})
		print("****************" + strRet)
		task.resume()
		print("hi hi hi hi " + strRet)
		return strRet
	}
	
	func loginPop(top: String, msg: String!) {
		let loginAlert = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
		loginAlert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default Action"), style: .default, handler: { _ in NSLog("The \"OK\" alert occurred.")}))
		loginAlert.title = top
		loginAlert.message = msg
		self.present(loginAlert, animated: true, completion: nil)
	}
	
}

