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
    lazy var servCon :ServerConnection = {
       var serverConnection =   ServerConnection()
        serverConnection.welcomeDel = self
        return serverConnection
    }()
    var busFieldGreeting : String = "Enter Bus Number"
    var connectPressed : Bool = false

    @IBOutlet weak var connectionStatus: UILabel!
    @IBOutlet weak var busIndexField: UITextField!
    @IBOutlet weak var connectActivity: UIActivityIndicatorView!
    
    lazy var busNumCheck : BusNumberChecker = {
        var checker :  BusNumberChecker = BusNumberChecker()
        checker.delegate = self
        return checker
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        busIndexField.userInteractionEnabled = false
        busIndexField.text = busFieldGreeting
        connectButton.userInteractionEnabled = false
        connectActivity.hidden = true
        connectionStatus.text = ""
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
    
    func getBusNumber() -> String? {
        return busNumberDisplay.text
    }
    
    @IBAction func connectPressed(sender: UIButton) {
        if !connectPressed {
            servCon.startConnection()
            connectPressed = true
            print("vcdilob daconnectebas")
            showLoading()
           // partnerFound()
        }
    }
    
    func showLoading(){
        connectActivity.hidden = false
        connectActivity.startAnimating()
        connectionStatus.text! = "Searching for Partner"
    }
    
    func partnerFound(){
        connectActivity.stopAnimating()
        connectActivity.hidden = true
        connectionStatus.text = ""
        performSegueWithIdentifier("chatStart", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dvc = segue.destinationViewController as? ChatViewController {
            if let id = segue.identifier where id == "chatStart" {
                    dvc.connection = servCon
                    servCon.chatDel = dvc
                    connectPressed = false
            }
        }
    }
    
    
    
}

