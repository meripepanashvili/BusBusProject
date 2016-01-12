//
//  ViewController.swift
//  BusBusProject
//
//  Created by Nino Basilaia on 12/16/15.
//  Copyright © 2015 Nino Basilaia. All rights reserved.
//

import UIKit


class WelcomeViewController: UIViewController, UITextFieldDelegate, BusNumberCheckerDelegate, UIAlertViewDelegate,
    WelcomePageDelegate

{
    @IBOutlet weak var connectButton: UIButton!

    @IBOutlet weak var busIndexField: UITextField!
    lazy var busNumCheck : BusNumberChecker = {
        var checker :  BusNumberChecker = BusNumberChecker()
        checker.delegate = self
        return checker
    }()
    
    let servCon  = ServerConnection()

    
    var busFieldGreeting : String = "Enter Bus Number"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        busIndexField.userInteractionEnabled = false
        busIndexField.text = busFieldGreeting
        connectButton.userInteractionEnabled = false
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var busNumberDisplay: UILabel!
    
    @IBAction func busIndexFinish(sender: UITextField) {
        busIndexField.userInteractionEnabled = false
        if let text = sender.text {
            busNumCheck.checkBusNumber(text)
            servCon.sendText(text)
        }
        
    }
    
    @IBAction func busIntexBegin(sender: UITextField) {
        sender.text! = ""
       
    }
  
    func finishedChecking(busNum: String, checkStatus: Bool, message: String?) {
        if checkStatus {
            busNumberDisplay.text = busNum
            connectButton.userInteractionEnabled = true
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
        let alert = UIAlertView(title: "Error in \(busNum)",
            message: alertMessage, delegate: self,
            cancelButtonTitle: "OK")

        alert.show()
        
    }
    
    @IBAction func connectPressed(sender: UIButton) {
        servCon.startConnection()
    }
    func partnerFound(){
    
    }
}

