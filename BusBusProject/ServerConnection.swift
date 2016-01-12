//
//  ServerConnection.swift
//  BusBusProject
//
//  Created by Meri Pepanashvili on 1/12/16.
//  Copyright © 2016 Nino Basilaia. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift

class ServerConnection: NSObject {
    let socket = SocketIOClient(socketURL: "localhost:8900")
    
    func startConnection(){
        self.addHandlers()
        self.socket.connect()
    }
    
    
    func addHandlers(){
        self.socket.on("chat") {[weak self] data, ack in
            print(data[0])
            return
        }
    }
}