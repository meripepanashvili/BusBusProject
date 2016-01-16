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
    var messageArray = [NSObject]()
    
    var parentView : WelcomeViewController?
    
    var myColor =  UIColor(red:26/255, green: 154/255, blue: 243/255, alpha: 0.3)
    var hisColor =  UIColor(red:26/255, green: 154/255, blue: 243/255, alpha: 0.5)
    
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
    
    var image : UIImage?
    var imagePicker: UIImagePickerController!
    
    @IBAction func takePhoto(sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera

        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePicker.dismissViewControllerAnimated(true, completion: { [weak self] in
            self?.sendPicture( self?.image, person: (self?.person1)!)
        })
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
    
    func createBubbleImage(index : Int, color : UIColor, person : CGFloat){
        let OffS = CGFloat(20)
        let image : UIImageView = UIImageView()
        let im : UIImage = (messageArray[index] as? UIImage)!
        image.image = resizeImage(im, newWidth: scrollView.frame.width/2)
        image.frame = CGRectMake(0, 0, scrollView.frame.size.width - 80, CGFloat.max)
        image.backgroundColor = color
        image.sizeToFit()
        if person == 1 {
            image.frame.origin.x = (scrollView.frame.size.width - image.frame.size.width) * person - OffS
        }
        else {
            image.frame.origin.x = (scrollView.frame.size.width - image.frame.size.width) * person + OffS/2
        }
        image.frame.origin.y = messageY
        image.clipsToBounds = true
        
        
        
        addFrame(OffS, contentFrame: image.frame, person: person)
        scrollView.addSubview(image)
    }
    
    func createBubbleMsg(index : Int, color : UIColor, person : CGFloat){
        let OffS = CGFloat(20)
        let message : UILabel = UILabel()
        message.frame = CGRectMake(0, 0, scrollView.frame.size.width - 80, CGFloat.max)
        message.numberOfLines = 0
        message.textColor = UIColor.blackColor()
        message.text = messageArray[index] as? String
        message.textAlignment = NSTextAlignment.Left
        message.sizeToFit()
        if person == 1 {
            message.frame.origin.x = (scrollView.frame.size.width - message.frame.size.width) * person - OffS
        }
        else {
            message.frame.origin.x = (scrollView.frame.size.width - message.frame.size.width) * person + OffS/2
        }
        message.frame.origin.y = messageY
        
        addFrame(OffS, contentFrame: message.frame, person: person)
        scrollView.addSubview(message)
    }
    
    func addFrame(OffS : CGFloat, contentFrame : CGRect, person : CGFloat ) {
        messageY += contentFrame.size.height + msgDist
        let frame : UILabel = UILabel()
        frame.frame.size = CGSizeMake(contentFrame.size.width + OffS, contentFrame.size.height + OffS)
        if person == 1 {
            frame.frame.origin = CGPoint(x: (scrollView.frame.size.width - frame.frame.size.width ) * person - OffS/2, y: frameY - OffS/2)
        }
        else {
            frame.frame.origin = CGPoint(x: (scrollView.frame.size.width - frame.frame.size.width ) * person , y: frameY - OffS/2)
        }
        if person == 1{
             frame.backgroundColor = myColor
        }
        else{
            frame.backgroundColor = hisColor
        }
       
        frame.layer.masksToBounds = true
        frame.layer.cornerRadius = 10
        scrollView.addSubview(frame)
        frameY += frame.frame.size.height + msgDist - OffS
    }
    
    func displayMessageOrImage(person : String, index : Int) {
        var pers : CGFloat = 0
        var color = hisColor
        if person == person1 {
            pers = 1
            color = myColor
        }
        if let _ =  messageArray[index] as? String {
            createBubbleMsg(index, color: color, person : pers)
        }
        else if let _ =  messageArray[index] as? UIImage {
            createBubbleImage(index ,color: color, person: pers)
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
        
        for (var index = 0; index < messageArray.count; index++) {
            if senderArray[index] == person1 {
                displayMessageOrImage(person1, index: index)
            } else {
                displayMessageOrImage(person2, index: index)
            }
        }
    }
    
    func appearMessage(message : String, person : String) {
        if message != "" {
            senderArray.append(person)
            messageArray.append(message)
            displayMessageOrImage(person, index: messageArray.count - 1)
        }
    }
    
    func getMessage(message : String) {
        appearMessage(message, person: person2)
    }
    
    func appearPicture(image : UIImage? ,person : String){
        if image != nil {
            senderArray.append(person)
            messageArray.append(image!)
            displayMessageOrImage(person, index: messageArray.count - 1)
        }
    }
    
    func sendPicture(image : UIImage? ,person : String){
        connection?.sendPicture(image )
        appearPicture(image, person: person)
     //   connection?.sendPicture(UIImage(named: "busbusPic.png")! )
       // appearPicture(UIImage(named: "busbusPic.png")!, person: person)
    }
    
    func getPicture(image : UIImage?){
        appearPicture(image, person: person2)
    }
    
    @IBAction func sendSoundRequest(sender: AnyObject) {
        connection?.sendSoundRequest()
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
            appearMessage(message, person: person1)
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
            appearMessage(message, person: person1)
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
        super.viewWillDisappear(true)
        if self.navigationController!.viewControllers.indexOf(self) == nil  {
            self.connection?.closeConnection()
            connection = nil
             parentView?.returnBusToOrigin()
        }
        
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
    }
    
}
