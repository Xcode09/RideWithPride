//
//  Extra.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 10/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
extension CGColor{
    class func colorForbtn()->CGColor{
        let color = UIColor(red: 57/255, green: 45/255, blue: 24/255, alpha: 1).cgColor
        return color
    }
}
extension RiderViewController{
    func ClearTextfeild(){
        emailtextfield.text  = ""
        Passwordtextfield.text = ""
    }
}
