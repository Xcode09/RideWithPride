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
extension CGColor{
    class func colorForbtn()->CGColor{
        let color = UIColor(red: 46/255, green: 57/255, blue: 24/255, alpha: 0.70).cgColor
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
extension DriverControlViewController{
    func ShowDriverDetail(snapshotUID:String){
        Database.database().reference().child("DriverUser").child(snapshotUID).observe(.value) { (data) in
            print(data)
            if let snap = data.value as? [String:Any]{
                print(snap)
                guard let name = snap["Name"] as? String else {return}
                print(name)
                self.Navi.topItem?.title = name
                guard let Emailname = snap["email"] as? String else {return}
            }else{
                print("Not Data")
            }
        }
    }
}
extension UITextField{
    func SetImage(imageName:String){
        let view = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
        view.image = UIImage(named: imageName)
        self.leftView = view
        self.contentMode = .scaleAspectFit
        self.leftViewMode = .always
    }
}
extension RiderViewController{
    func ClearTextfeild(){
        emailtextfield.text  = ""
        Passwordtextfield.text = ""
    }
}
