//
//  ExtenCallRideViewcontroller.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 20/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
extension CallRideViewController{
    func geoloaction(){
        let geo = CLGeocoder()
        let CLLoaction = CLLocation(latitude: (userloaction?.latitude)!, longitude: (userloaction?.longitude)!)
        geo.reverseGeocodeLocation(CLLoaction) { (placemark, error) in
            if error != nil{
                
            }else{
                guard let place = placemark?.first else {return}
                self.label.text = place.subLocality
                
            }
            
        }
    }
     func extractedFuncofconstraints() {
        map.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        map.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        map.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        map.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
                viewshow.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
                viewshow.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
                viewshow.topAnchor.constraint(equalTo: view.topAnchor , constant:30).isActive=true
                viewshow.widthAnchor.constraint(equalToConstant: view.frame.width).isActive=true
                viewshow.heightAnchor.constraint(equalToConstant: 50).isActive=true
    }
  func labelShow(){
        self.viewshow.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.bold)
        label.textAlignment = .justified
        label.topAnchor.constraint(equalTo: viewshow.topAnchor, constant: 16).isActive=true
        label.bottomAnchor.constraint(equalTo: viewshow.bottomAnchor, constant: 16).isActive=true
        label.leftAnchor.constraint(equalTo: viewshow.leftAnchor, constant: 16).isActive=true
        label.rightAnchor.constraint(equalTo: viewshow.rightAnchor, constant: 16).isActive=true
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

