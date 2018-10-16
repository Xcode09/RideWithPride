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

class AllCodesList{
    typealias codes = ((_ Dictionary:NSDictionary)->Void)
    static func AllCodes(compilation: @escaping codes){
        
        guard let st = Bundle.main.path(forResource: "File", ofType: "txt") else {return}
        let url = URL(fileURLWithPath: st)
        do{
            let data = try Data(contentsOf: url)
            guard let json = try JSONSerialization.jsonObject(with: data, options:.mutableContainers) as? [NSDictionary] else {return}
            for js in json{
                compilation(js)
            }
            
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
}
