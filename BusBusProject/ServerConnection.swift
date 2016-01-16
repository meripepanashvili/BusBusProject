//
//  ServerConnection.swift
//  BusBusProject
//
//  Created by Meri Pepanashvili on 1/12/16.
//  Copyright © 2016 Nino Basilaia. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

protocol ChatDelegate {
    func getMessage(message : String)
    func chatFinished()
    func getSoundRequest()
    func getPicture(image : UIImage?)
}

protocol WelcomePageDelegate {
    func getAlertFromServer(title : String, message : String)
    func partnerFound()
    func getBusNumber() -> String?
}
class ServerConnection: NSObject, LocationDelegate {
    
    let socket = SocketIOClient(socketURL: "omedialab.com:8084")
    var chatDel : ChatDelegate?
    var welcomeDel: WelcomePageDelegate?
    var location = LocationGetter()
    let compression : CGFloat = 0.2
    
    func initServerConnection(){
        self.addHandlers()
        location.delegate = self
        location.initLocation()
    }
    
    func startConnection(){
        self.socket.connect()
        self.socket.emit("find partner")
        
    }
    
    func foundLoaction(latitude: Double, longitude: Double) {
        self.socket.emit("recieve location", latitude, longitude)
    }
    
    func addHandlers(){
        self.socket.on("partner text") {[weak self] data, ack in
            if let del = self!.chatDel {
                del.getMessage(data[0] as! String)
            }
            return
        }
        
        self.socket.on("partner found"){ [weak self] data in
            print("gipove kavshiri")
            self?.welcomeDel?.partnerFound()
            return
        }
        
        self.socket.on("get location") { [weak self] data in
            if let locMessage =  self?.location.getLocation() {
                self?.welcomeDel?.getAlertFromServer("Location Alert", message: locMessage)
                self?.socket.emit("recieve location", -1, -1)
            }
            
        }
        
        self.socket.on("disconnect"){ [weak self] data in
            self?.chatDel?.chatFinished()
            self?.chatDel = nil
            print("disconnectshi movedi")
        }
        
        
        self.socket.on("get bus number"){ [weak self] data in
            if let busNum = self?.welcomeDel?.getBusNumber() {
                self?.socket.emit("bus number", busNum)
            }
            return
        }
        
        self.socket.on("make sound") { [weak self] data in
            self?.chatDel?.getSoundRequest()
        }
        
        self.socket.on("download picture") {[weak self] data, ack in
            let imageEncode = data[0] as! String
            let imageData = NSData(base64EncodedString: imageEncode, options: NSDataBase64DecodingOptions(rawValue: 0))
            let image = UIImage(data: imageData!)
            self?.chatDel?.getPicture(image)
        }
        
    }
    
    func sendPicture(image : UIImage?){
        if let im = image {
            if let imageData = UIImageJPEGRepresentation(im, compression)  {
                let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
                socket.emit("send picture", base64String)
            }
            
        }
        
    }
    
    
    func sendSoundRequest(){
        socket.emit("make sound")
    }
    
    func closeConnection(){
        chatDel = nil
        socket.disconnect()
        print("socketebshi davkete socketi")
    }
    
    func sendText(message : String){
        self.socket.emit("chat", message)
    }
}
