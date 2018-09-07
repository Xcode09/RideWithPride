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
}
extension CGColor{
    class func colorForbtn()->CGColor{
        let color = UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 0.70).cgColor
        return color
    }
  
}
extension UIButton{
      func GradientColor(){
        let CAGradient = CAGradientLayer()
        CAGradient.frame = CGRect(x: 16, y: 584, width: 343, height: 55)
        let color = UIColor(red: 44, green: 25, blue: 228, alpha: 1.0)
        let color2 = UIColor(red: 143, green: 0, blue: 254, alpha: 1.0)
        CAGradient.colors = [color.cgColor,color2.cgColor]
        CAGradient.startPoint = CGPoint(x: 0.0, y: 0.95)
        CAGradient.endPoint = CGPoint(x: 1.0, y: 0.05)
        //CAGradient.locations = [0.0,1.0]
        self.layer.addSublayer(CAGradient)
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
extension DriverControlViewController{
    func ShowDriverDetail(snapshotUID:String){
        Database.database().reference().child("DriverUser").child(snapshotUID).observe(.value) { (data) in
            print(data)
            if let snap = data.value as? [String:Any]{
                print(snap)
                guard let name = snap["Name"] as? String else {return}
                print(name)
                self.title = name
                guard let Emailname = snap["email"] as? String else {return}
            }else{
                print("Not Data")
            }
        }
    }
}

extension RiderViewController{
    func ClearTextfeild(){
        emailtextfield.text  = ""
        Passwordtextfield.text = ""
    }
}
