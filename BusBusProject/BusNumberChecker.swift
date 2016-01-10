//
//  BusNumberChecker.swift
//  BusBusProject
//
//  Created by Meri Pepanashvili on 1/10/16.
//  Copyright © 2016 Nino Basilaia. All rights reserved.
//

import UIKit


protocol BusNumberCheckerDelegate {
    func finishedChecking(busNum : String, checkStatus : Bool, message : String?)
}

class BusNumberChecker: NSObject {
    var delegate : BusNumberCheckerDelegate?
    var numberLength = 7
    
    func checkBusNumber(busNum: String){
        var valid : Bool = true
        var message : String? = nil
        var finalNum : String = ""
        
        if let del = delegate {
            let length = busNum.characters.count
            if length < numberLength {
                del.finishedChecking(busNum, checkStatus: false, message: "Bus Number is too short")
                return
            
            }
            else if length > numberLength{
                del.finishedChecking(busNum, checkStatus: false, message: "Bus Number is too long")
            }
            
            var index = 1
            finalNum = busNum.uppercaseString
            for character in finalNum.characters {
                if index <= 3 {
                    if character < "A" || character > "Z"{
                        valid = false
                        message = "First letters are wrong"
                        break
                    }
                }
                else if index > 4 {
                    if character < "0" || character > "9" {
                        valid = false
                        message = "Final three characters should be numbers"
                        break
                
                    }
                    
                }
                else{
                    if character != "-" {
                        valid  = false
                        message = "Letters and numbers should be separated by \"-\""
                        break
                    }
                }
                index++
            }
            if valid {
                del.finishedChecking(finalNum, checkStatus: valid, message: message)
            }
            else {
                del.finishedChecking(busNum, checkStatus: valid, message: message)
            }
            
        }
        
    }
    
}
