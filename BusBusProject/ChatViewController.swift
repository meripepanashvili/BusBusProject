//
//  ChatViewController.swift
//  BusBusProject
//
//  Created by Nino Basilaia on 12/18/15.
//  Copyright © 2015 Nino Basilaia. All rights reserved.
//

import UIKit
import AVFoundation

class ChatViewController: UIViewController, UITextFieldDelegate, ChatDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageField: UITextField!
    
    var connection : ServerConnection?
    var messageY : CGFloat = 0
    var frameY : CGFloat = 0
    var msgDist : CGFloat = 30
    var keyboardHidden = true
    var quote : String = ""
    
    var person1 : String = "person1"
    var person2 : String = "person2"
    
    var senderArray = [String]()
    var messageArray = [String]()
    
    var parentView : WelcomeViewController?
    
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var popUpView: UIView!
    var presenting = false
    
    @IBAction func popUp(sender: AnyObject) {
        view.endEditing(true)
        if self.presenting {
            animatePopUp(0)
        } else {
            animatePopUp(-popUpView.frame.height)
        }
    }
    
    func animatePopUp(height : CGFloat){
        let offScreen = CGAffineTransformMakeTranslation(0, height)
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.8, options: [], animations: {
            self.chatView.transform = offScreen
            self.presenting = !self.presenting
            self.popUpView.transform = CGAffineTransformIdentity
            }, completion: { finished in })
    }
    
    var imageView = UIImageView()
    var imagePicker: UIImagePickerController!
    
    @IBAction func takePhoto(sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera

        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        createBubbleImage(UIColor.yellowColor(), person: 1)
        
        scrollView.contentSize = CGSize(width: 0, height: messageY)
        let bottomOffset:CGPoint = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: false)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func createBubbleImage(color : UIColor, person : CGFloat){
        let image : UIImageView = UIImageView()
        image.image = resizeImage(imageView.image!, newWidth: scrollView.frame.width/2)
        image.frame = CGRectMake(0, 0, scrollView.frame.size.width - 80, CGFloat.max)
        image.backgroundColor = color
        image.sizeToFit()
        image.frame.origin.x = (scrollView.frame.size.width - image.frame.size.width) * person
        image.frame.origin.y = messageY
        image.clipsToBounds = true
        
        messageY += image.frame.size.height + msgDist
        
        let OffS = CGFloat(10)
        let frame : UILabel = UILabel()
        frame.frame.size = CGSizeMake(image.frame.size.width + OffS, image.frame.size.height + OffS)
        frame.frame.origin = CGPoint(x: (scrollView.frame.size.width - frame.frame.size.width) * person, y: frameY)
        frame.backgroundColor = color
        frame.layer.masksToBounds = true
        frame.layer.cornerRadius = 10
        scrollView.addSubview(frame)
        scrollView.addSubview(image)
        
        frameY += frame.frame.size.height + msgDist - OffS
    }
    
    func createBubbleMsg(index : Int, color : UIColor, person : CGFloat){
        let OffS = CGFloat(20)
        let message : UILabel = UILabel()
        message.frame = CGRectMake(0, 0, scrollView.frame.size.width - 80, CGFloat.max)
        //message.backgroundColor = color
        message.numberOfLines = 0
        message.textColor = UIColor.blackColor()
        message.text = messageArray[index]
        message.textAlignment = NSTextAlignment.Left
        message.sizeToFit()
        if person == 1 {
            message.frame.origin.x = (scrollView.frame.size.width - message.frame.size.width) * person - OffS
        }
        else {
            message.frame.origin.x = (scrollView.frame.size.width - message.frame.size.width) * person + OffS/2
        }
        message.frame.origin.y = messageY
        
        messageY += message.frame.size.height + msgDist
        
        
        let frame : UILabel = UILabel()
        frame.frame.size = CGSizeMake(message.frame.size.width + OffS, message.frame.size.height + OffS)
        if person == 1 {
            frame.frame.origin = CGPoint(x: (scrollView.frame.size.width - frame.frame.size.width ) * person - OffS/2, y: frameY - OffS/2)
        }
        else {
             frame.frame.origin = CGPoint(x: (scrollView.frame.size.width - frame.frame.size.width ) * person , y: frameY - OffS/2)
        }
        
        frame.backgroundColor = UIColor(red:26/255, green: 154/255, blue: 243/255, alpha: 0.7)
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
    
    @IBAction func sendSoundRequest(sender: AnyObject) {
        let alertController = UIAlertController(title: "ხმოვანი სიგნალის შეთავაზება", message: "ხმოვანი სიგნალის შემოთავაზება გაგზავნილია", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "დახურვა", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func getSoundRequest(){
        let alertController = UIAlertController(title: "ხმოვანი სიგნალის შემოთავაზება", message: "გინდა შენმა ტელეფონმა ხმა გამოსცეს?", preferredStyle: .Alert)
        
        let allow = UIAlertAction(title: "კი", style: .Default, handler: {(alert: UIAlertAction!) in
            var mySound: SystemSoundID = 0
            if let soundURL = NSBundle.mainBundle().URLForResource("sound", withExtension: "wav") {
                AudioServicesCreateSystemSoundID(soundURL, &mySound)
                AudioServicesPlaySystemSound(mySound);
            }
        })
        alertController.addAction(allow)
        let dontAllow = UIAlertAction(title: "არა", style: .Default, handler: nil)
        alertController.addAction(dontAllow)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func chatFinishedAlert() {
        let alertController = UIAlertController(title: "Disconnect", message: "Chat is diconnected", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: {(alert: UIAlertAction!) in
            self.navigationController?.popToRootViewControllerAnimated(true)
        })
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func chatFinished() {
        chatFinishedAlert()
        connection?.chatDel = nil
        connection = nil
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
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

        if quote != "" {
            messageField.text = quote
        }
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
        if presenting {
            animatePopUp(0)
        }
    }
    
    func rotated () {
        refresh()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if presenting {
            animatePopUp(0)
        }
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
        connection = nil
        parentView?.returnBusToOrigin()
        //print("vxurav fanjaras")
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        
    }
    
}
