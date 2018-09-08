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
        let color = UIColor(red: 80/255, green: 227/255, blue: 194/255, alpha: 0.70).cgColor
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
