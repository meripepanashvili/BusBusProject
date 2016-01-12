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
    
}

protocol WelcomePageDelegate{
    func partnerFound()
}
class ServerConnection: NSObject {
    
    let socket = SocketIOClient(socketURL: "omedialab.com:8084")
    var chatDel : ChatDelegate?
    var welcomeDel: WelcomePageDelegate?
    
    func startConnection(){
        self.addHandlers()
        self.socket.connect()
        self.socket.emit("find partner")
    }
    
    
    func addHandlers(){
        self.socket.on("partner text") {[weak self] data, ack in
            if let del = self!.chatDel {
                del.getMessage(data[0] as! String)
            }
            return
        }
        
        self.socket.on("partner found"){ [weak self] data in
            self?.welcomeDel?.partnerFound()
        }
        
        self.socket.on("disconnect"){ [weak self] data in
            self?.chatDel?.chatFinished()
        }
        
        self.socket.on("coordinates"){ [weak self] data in
            //send coordinates
        }
        
    }
    
    func closeConnection(){
        socket.close()
    }
    
    func sendText(message : String){
        self.socket.emit("chat", message)
    }
}
