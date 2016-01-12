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
    func partnerNotAvaliable()
    func partnerFound()
}
class ServerConnection: NSObject {
    let socket = SocketIOClient(socketURL: "omedialab.com:8084")
    var chatDel : ChatDelegate?
    var welcomeDel: WelcomePageDelegate?
    
    func startConnection(){
        self.addHandlers()
        self.socket.connect()
    }
    
    
    func addHandlers(){
        self.socket.on("partner text") {[weak self] data, ack in
            print(data[0])
            print("shemovediii")
            return
        }
    }
    
    func sendText(message : String){
        self.socket.emit("chat", message)
    }
}
