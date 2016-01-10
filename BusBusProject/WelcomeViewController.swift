//
//  ViewController.swift
//  BusBusProject
//
//  Created by Nino Basilaia on 12/16/15.
//  Copyright © 2015 Nino Basilaia. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UITextFieldDelegate, BusNumberCheckerDelegate {

    @IBOutlet weak var busIndexField: UITextField!
    lazy var busNumCheck : BusNumberChecker = {
        var checker :  BusNumberChecker = BusNumberChecker()
        checker.delegate = self
        return checker
    }()
    
    
    var busFieldGreeting : String = "Enter Bus Number"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        busIndexField.userInteractionEnabled = false
        busIndexField.text = busFieldGreeting
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func busIndexFinish(sender: UITextField) {
        busIndexField.userInteractionEnabled = false
        if let text = sender.text {
            busNumCheck.checkBusNumber(text)
        }
        
    }
    
    @IBAction func busIntexBegin(sender: UITextField) {
        sender.text! = ""
       
    }
  
    func finishedChecking(busNum: String, checkStatus: Bool, message: String?) {
        if checkStatus {
            print(busNum)
            
        }
        else {
            if message != nil {
                busNumberErrorAlert(busNum ,alertMessage: message!)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        busIndexField.userInteractionEnabled = true
    }
    
    func busNumberErrorAlert(busNum : String ,alertMessage : String) {
        let alert=UIAlertController(title: "Error in \(busNum)", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert);
        let okAction = UIAlertAction(title: "OK", style: .Default) { (alert: UIAlertAction!) -> Void in
            
        }
        alert.addAction(okAction)
        //show it
        presentViewController(alert, animated: true, completion: nil)
        
        
    }

}

