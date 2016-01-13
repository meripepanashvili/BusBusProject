//
//  ChatViewController.swift
//  BusBusProject
//
//  Created by Nino Basilaia on 12/18/15.
//  Copyright © 2015 Nino Basilaia. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITextFieldDelegate, ChatDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageField: UITextField!
    
    var connection : ServerConnection?
    var messageY : CGFloat = 0
    var frameY : CGFloat = 0
    var msgDist : CGFloat = 30
    var keyboardHidden = true
    
    var person1 : String = "person1"
    var person2 : String = "person2"
    
    var senderArray = [String]()
    var messageArray = [String]()
    
    
    func createBubbleMsg(index : Int, color : UIColor, person : CGFloat){
        let message : UILabel = UILabel()
        message.frame = CGRectMake(0, 0, scrollView.frame.size.width - 80, CGFloat.max)
        message.backgroundColor = color
        message.numberOfLines = 0
        message.textColor = UIColor.blackColor()
        message.text = messageArray[index]
        message.textAlignment = NSTextAlignment.Left
        message.sizeToFit()
        message.frame.origin.x = (scrollView.frame.size.width - message.frame.size.width) * person
        message.frame.origin.y = messageY
        
        messageY += message.frame.size.height + msgDist
        
        let OffS = CGFloat(10)
        let frame : UILabel = UILabel()
        frame.frame.size = CGSizeMake(message.frame.size.width + OffS, message.frame.size.height + OffS)
        frame.frame.origin = CGPoint(x: (scrollView.frame.size.width - frame.frame.size.width) * person, y: frameY)
        frame.backgroundColor = color
        frame.layer.masksToBounds = true
        frame.layer.cornerRadius = 10
        scrollView.addSubview(frame)
        scrollView.addSubview(message)
        
        frameY += frame.frame.size.height + msgDist - OffS
    }
    
    func displayMessage(person : String, index : Int) {
        if person == person1 {
            createBubbleMsg(index, color: UIColor.yellowColor(), person : 1)
        } else {
            createBubbleMsg(index, color: UIColor.groupTableViewBackgroundColor(), person: 0)
        }
        scrollView.contentSize = CGSize(width: 0, height: messageY)
        let bottomOffset:CGPoint = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: false)
    }
    
    func refresh(){
        messageY = 0
        frameY = 0
        
        for subView in scrollView.subviews {
            subView.removeFromSuperview()
        }
        
        for (var index = 0; index < messageArray.count - 1; index++) {
            if senderArray[index] == person1 {
                displayMessage(person1, index: index)
            } else {
                displayMessage(person2, index: index)
            }
        }
    }
    
    func send(message : String, person : String) {
        if message != "" {
            senderArray.append(person)
            messageArray.append(message)
            displayMessage(person, index: messageArray.count - 1)
        }
    }
    
    func getMessage(message : String) {
        send(message, person: person2)
    }
    
    func chatFinishedAlert() {
        let alert = UIAlertView(title: "Disconnect",
            message: "Chat is diconnected", delegate: self,
            cancelButtonTitle: "OK")
        alert.show()
        
    }
    
    func chatFinished() {
        chatFinishedAlert()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func sendMessage(sender: UIButton) {
        if let message = messageField.text {
            send(message, person: person1)
            connection?.sendText(message)
        }
        messageField.text = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 0, height: 0)
        messageField.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        let tapScrollViewGesture = UITapGestureRecognizer(target: self, action: "didTapScrollView")
        tapScrollViewGesture.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tapScrollViewGesture)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let message = textField.text {
            send(message, person: person1)
            connection?.sendText(message)
        }
        messageField.text = ""
        return true
    }
    
    func didTapScrollView() {
        view.endEditing(true)
    }
    
    func rotated () {
        refresh()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            if keyboardHidden {
                view.frame.origin.y -= keyboardSize.height
            }
        }
        keyboardHidden = false
    }
    
    func keyboardWillHide(notification: NSNotification) {
        keyboardHidden = true
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            view.frame.origin.y += keyboardSize.height
        }
    }
    
    @IBAction func unwindToViewController (sender: UIStoryboardSegue){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 
    override func viewWillDisappear(animated: Bool) {
        self.connection?.closeConnection()
        print("vxurav fanjaras")
    }
    
}
