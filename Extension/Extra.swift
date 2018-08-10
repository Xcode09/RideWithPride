//
//  Extra.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 10/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import CoreLocation
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
extension RiderViewController{
    func ClearTextfeild(){
        emailtextfield.text  = ""
        Passwordtextfield.text = ""
    }
}
