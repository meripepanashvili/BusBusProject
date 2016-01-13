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
    func respondOnMakeSound()
    
}

protocol WelcomePageDelegate{
    func partnerFound()
    func getBusNumber() -> String?
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
            print("gipove kavshiri")
            self?.welcomeDel?.partnerFound()
            return
        }
        
       self.socket.on("disconnect"){ [weak self] data in
           self?.chatDel?.chatFinished()
           self?.chatDel = nil
           print("disconnectshi movedi")
       }
        
//        self.socket.on("partner disconnect"){ [weak self] data in
//            self?.chatDel?.chatFinished()
//            self?.socket.disconnect()
//            print("disconnectshi movedi")
//            return
//        }
        
        self.socket.on("get bus number"){ [weak self] data in
            if let busNum = self?.welcomeDel?.getBusNumber() {
                self?.socket.emit("bus number", busNum)
            }
            return
        }
        
        self.socket.on("make sound") { [weak self] data in
            self?.chatDel?.respondOnMakeSound()
        }
        
        self.socket.on("download picture") { [weak self] data in
            //
        
        }
        
        self.socket.on("coordinates"){ [weak self] data in
            //send coordinates
        }
        
        self.socket.on("test"){ [weak self] data in
            print("agervar")
            return
        }
        
    }
    
    func askToMakeSound(){
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
