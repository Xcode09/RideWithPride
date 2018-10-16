//
//  Extra.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 10/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase
import GoogleMaps
class ExtraThings:NSObject{
    class func ErrorAlertShow(Title:String,Message:String)->UIAlertController{
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        return alert
        
    }
    class func Cleartext(NameField:UITextField,passwordfiled:UITextField,_ feild:UITextField?=nil,_ fie:UITextField?=nil,filed:UITextField?=nil,_ extra:UITextField?=nil){
        NameField.text = ""
        passwordfiled.text = ""
        feild?.text = ""
        fie?.text = ""
        filed?.text = ""
        extra?.text = ""
    }
    class func KeyboardManagement(top:NSLayoutConstraint,cot:Int){
       let topvalue = top.constant
           let cont = -cot
        NotificationCenter.default.addObserver(forName:Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (noti) in
            if noti.userInfo != nil{
                //let frame = user[UIKeyboardFrameEndUserInfoKey] as! CGRect
                top.constant = CGFloat(0 + cont)
            }
            
            
            
        }

    NotificationCenter.default.addObserver(forName:Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (noti) in
            top.constant = topvalue
            
            
            
        }
    }
    class func KeyboardManagement(view:UIView){
        
        NotificationCenter.default.addObserver(forName:Notification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (noti) in
            if noti.userInfo != nil{
                //let frame = user[UIKeyboardFrameEndUserInfoKey] as! CGRect
                view.frame.origin.y = -78
            }
            
            
            
        }
        
        NotificationCenter.default.addObserver(forName:Notification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { (noti) in
            
            view.frame.origin.y = 0
            
            
        }
    }
    
    class func DrawRoutBetween(driverlocation:CLLocationCoordinate2D,userloaction:CLLocationCoordinate2D,textviews:UITextView,map:GMSMapView){
        let value1 = Double((userloaction.latitude))
        let value2 = Double((userloaction.longitude))
        let origin = "\(value1),\(value2)"
        let end1 = Double(driverlocation.latitude)
        let end2 = Double(driverlocation.longitude)
        let destination = "\(end1),\(end2)"
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyAD-HkzDylnNuf4KJxQvM4uypcK4GA_Zog")!
        let task = URLSession.shared.dataTask(with: url) { (data, res, error) in
            if error != nil{
                print(String(describing: error?.localizedDescription))
            }else{
                guard let data = data else {
                    print("data is not found")
                    return
                    
                }
                
                do{
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                        print("Json is not found")
                        return
                    }
                    if let overlimited = json["status"] as? String{
                        let lc = CLLocation(latitude: driverlocation.latitude, longitude: driverlocation.longitude)
                        let rc = CLLocation(latitude: userloaction.latitude, longitude: userloaction.longitude)
                        ExtraThings.Distance(lc: lc, rc: rc, textviews: textviews)
                        return
                    }
                    guard let preRoutes = json["routes"] as? NSArray ,preRoutes.count > 0 else{
                        fatalError("Not found array")
                    }
                    
                    let routes = preRoutes[0] as! NSDictionary
                    let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                    
                    
                    let polyString = routeOverviewPolyline.object(forKey: "points") as! String
                    DispatchQueue.main.async {
                        let path = GMSMutablePath(fromEncodedPath: polyString)
                        let polyline = GMSPolyline(path: path)
                        polyline.strokeColor = .orange
                        polyline.strokeWidth = 10
                        polyline.map = map
                        
                        let makerr = GMSMarker()
                        makerr.position = driverlocation
                        makerr.map = map
                        let lc = CLLocation(latitude: driverlocation.latitude, longitude: driverlocation.longitude)
                        let rc = CLLocation(latitude: userloaction.latitude, longitude: userloaction.longitude)
                        ExtraThings.Distance(lc: lc, rc: rc, textviews: textviews)
                    }
                    
                }catch{
                    
                }
            }
        }
        task.resume()
        
    }
    class func Distance(lc:CLLocation,rc:CLLocation,textviews:UITextView){
        let distance = lc.distance(from: rc)/1000
        let rounded = round(distance * 100) / 100
        DispatchQueue.main.async {
            textviews.isHidden = false
            textviews.text = " \(rounded) KM Away"
        }
        
    }
    typealias Compilation = ((String)->Void)
    class func ShowDriverDetail(snapshotUID:String,ChildNode:String,compilation:@escaping Compilation){
        Database.database().reference().child(ChildNode).child(snapshotUID).observe(.value) { (data) in
            print(data)
            if let snap = data.value as? [String:Any]{
                guard let name = snap["Name"] as? String else {
                    return
                }
                compilation(name)
                
            }else{
                print("Not Data")
            }
        }
    }
}
extension CGColor{
    class func colorForbtn()->CGColor{
        let color = UIColor(red: 241/255, green: 122/255, blue: 62/255, alpha: 1.0).cgColor
        return color
    }
    class func ColorCombination()->CGColor{
        let color = UIColor(red: 42/255, green: 91/255, blue: 120/255, alpha: 1.0).cgColor
        return color
    }
    
}
extension UIImageView{
    func CreateImageView(Image name:String)->UIImageView{
        let image:UIImageView={
            let image = UIImageView()
            image.contentMode = .scaleAspectFill
            image.translatesAutoresizingMaskIntoConstraints=false
            image.image = UIImage(named: name)
            image.clipsToBounds = true
            return image
        }()
        return image
    }
    
}

extension RiderViewController{
    func ClearTextfeild(){
        emailtextfield.text  = ""
        Passwordtextfield.text = ""
    }
}
