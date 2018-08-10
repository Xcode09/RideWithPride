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
   typealias  compilation = ((Double,String,CLLocation)->Void)
    static func AllRides(compilation:@escaping compilation,DriverLocation:CLLocationCoordinate2D){
        Database.database().reference().child("loaction").observe(.childAdded) { (data) in
            if let sanpshot = data.value as? [String:Any]{
                guard let email = sanpshot["email"] as? String else{
                    print("Email is not found")
                    return}
                guard let latitude = sanpshot["lati"] as? Double else{print("lati is not found")
                    return}
                guard let logtitude = sanpshot["long"] as? Double else{print("log is not found")
                    return}
                print(latitude)
                let driveroaction = CLLocation(latitude: (DriverLocation.latitude), longitude: (DriverLocation.longitude))
                let riderloaction = CLLocation(latitude: latitude, longitude: logtitude)
                let distance = driveroaction.distance(from: riderloaction)/1000
                let rounded = round(distance * 100) / 100
                compilation(rounded,email,riderloaction)
        }
    }
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
