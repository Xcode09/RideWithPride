//
//  place.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 10/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
class ExtraThings:NSObject{
    class func ErrorAlertShow(Title:String,Message:String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
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
