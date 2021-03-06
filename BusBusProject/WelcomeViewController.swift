//
//  ViewController.swift
//  BusBusProject
//
//  Created by Nino Basilaia on 12/16/15.
//  Copyright © 2015 Nino Basilaia. All rights reserved.
//

import UIKit


class WelcomeViewController: UIViewController, UITextFieldDelegate, BusNumberCheckerDelegate, UIAlertViewDelegate,
    WelcomePageDelegate, UIApplicationDelegate
    
{
    @IBOutlet weak var connectButton: UIButton!
    var servCon : ServerConnection? //= ServerConnection()
    var busFieldGreeting : String = "Enter Bus Number"
    var connectPressed : Bool = false
    var busLocation : CGPoint = CGPoint(x: 0, y: 0)
    
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
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        servCon = appDelegate.servCon
        servCon?.welcomeDel = self
        servCon?.initServerConnection()
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
        }
        sender.text! = ""
    }
    
    @IBAction func busIntexBegin(sender: UITextField) {
        sender.text! = ""
        
    }
    
    func finishedChecking(busNum: String, checkStatus: Bool, message: String?) {
        if checkStatus {
            busNumberDisplay.text = busNum
            connectButton.userInteractionEnabled = true
            busIndexField.resignFirstResponder()
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
    
    func getAlertFromServer(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func busNumberErrorAlert(busNum : String ,alertMessage : String) {
        let alertController = UIAlertController(title: "Error in \(busNum)", message: alertMessage, preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "Okay",
            style: UIAlertActionStyle.Default,
            handler: {(alert: UIAlertAction!) in self.busIndexField.becomeFirstResponder()
        }))
        
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func getBusNumber() -> String? {
        return busNumberDisplay.text
    }
    
    @IBAction func connectPressed(sender: UIButton) {
        if !connectPressed {
            if let connection = servCon {
                connection.startConnection()
                connectPressed = true
                showLoading()
            }
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
        animatePopUp()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let dvc = segue.destinationViewController as? ChatViewController {
            if let id = segue.identifier where id == "chatStart" {
                
                dvc.connection = servCon
                servCon?.chatDel = dvc
                connectPressed = false
                dvc.parentView = self
            }
        }
    }
    
    func returnBusToOrigin(){
        
        let offScreen = CGAffineTransformMakeTranslation(0,0)
        UIView.animateWithDuration(0, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.1, options: [], animations: {
            self.connectButton.transform = offScreen
            }, completion: { finished in })
    }
    
    func animatePopUp(){
        let offScreen = CGAffineTransformMakeTranslation(view.frame.width, 0)
        busLocation = connectButton.frame.origin
        UIView.animateWithDuration(3, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 0.01, options: [], animations: {
            self.connectButton.transform = offScreen
            }, completion: {[weak self] finished in
                self?.performSegueWithIdentifier("chatStart", sender: nil)
            })
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        if self.navigationController!.viewControllers.indexOf(self) == nil  {
            self.servCon?.closeConnection()
            servCon = nil
        }
        
    }    
    
    func applicationWillTerminate(application: UIApplication) {
         self.servCon?.closeConnection()
    }
    
    @IBAction func didTapView(sender: UITapGestureRecognizer?) {
        view.endEditing(true)
    }
    
}

