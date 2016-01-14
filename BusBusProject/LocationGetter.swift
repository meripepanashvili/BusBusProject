//
//  LocationGetter.swift
//  BusBusProject
//
//  Created by Meri Pepanashvili on 1/13/16.
//  Copyright © 2016 Nino Basilaia. All rights reserved.
//

import UIKit
import MapKit

protocol LocationDelegate {
    func foundLoaction( latitude : Double, longitude : Double)
}

class LocationGetter: NSObject, CLLocationManagerDelegate {
    var manager = CLLocationManager()
    var enabled : Bool = false
    var delegate : LocationDelegate?
    
    func initLocation(){
        self.manager.requestAlwaysAuthorization()
        self.manager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.manager.delegate = self
            self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            enabled = true
        }
        print("init location")
    }
    
    func getLocation() -> String?{
        if enabled {
            self.manager.startUpdatingLocation()
            print("enabled location")
            return nil
        }
        else {
            return "location services are not avaliable"
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations[locations.endIndex-1]
        let coordinate: CLLocationCoordinate2D = lastLocation.coordinate
        if let del = delegate {
            print(coordinate)
            del.foundLoaction(Double(coordinate.latitude ), longitude: Double(coordinate.longitude))
        }
        
        
    }
    
}
