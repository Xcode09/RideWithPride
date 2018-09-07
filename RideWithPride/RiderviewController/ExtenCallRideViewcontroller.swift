//
//  ExtenCallRideViewcontroller.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 20/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import Foundation
import CoreLocation
import GooglePlaces
import GoogleMaps
extension CallRideViewController{
     func extractedFuncofconstraints() {
        map.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive=true
        map.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        map.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        map.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches Start")
        LocationManager.stopUpdatingLocation()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch end")
        LocationManager.startUpdatingLocation()
    }
    
    
}

