//
//  Rides.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 20/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import FirebaseDatabase
struct Riders{
    typealias  compilation = ((Double,CLLocation)->Void)
    static var riders = [DataSnapshot]()
    static var emails = Set<String>()
    static func AllRides(compilation:@escaping compilation,DriverLocation:CLLocationCoordinate2D){
        Database.database().reference().child("loaction").observe(.childAdded) { (data) in
            riders.append(data)
            for email in riders{
                if let snaps=email.value as? [String:Any]{
                    guard let ema = snaps["email"] as? String else {return}
                    emails.insert(ema)
                guard let latitude = snaps["lati"] as? Double else{print("lati is not found")
                    return}
                guard let logtitude = snaps["long"] as? Double else{print("log is not found")
                    return}
                    let riderloaction = CLLocation(latitude: latitude, longitude: logtitude)
                    let rounded=Riders.calculateDistance(DriverLocation: DriverLocation, RiderLocation: riderloaction.coordinate)
                    compilation(rounded,riderloaction)
            }
        }
    }
}
    static func calculateDistance(DriverLocation:CLLocationCoordinate2D,RiderLocation:CLLocationCoordinate2D)->Double{
        let driveroaction = CLLocation(latitude: (DriverLocation.latitude), longitude: (DriverLocation.longitude))
        let riderloaction = CLLocation(latitude: RiderLocation.latitude, longitude: RiderLocation.longitude)
        let distance = driveroaction.distance(from: riderloaction)/1000
        let rounded = round(distance * 100) / 100
        return rounded
    }
}
extension DriverLoginViewController{
 func KeyboardManagement(){
        NotificationCenter.default.addObserver(forName:Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (noti) in
            let user  = (noti.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
            print(noti)
            self.view.frame.origin.y = -70


    }
    NotificationCenter.default.addObserver(forName:Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (noti) in
        let user  = (noti.userInfo!["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        self.view.frame.origin.y = 0
        
        
    }
    }
    
}
