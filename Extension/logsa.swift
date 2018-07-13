//
//  logsa.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 10/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
class logsa: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func log(_ sender:UIButton){
        do{
            try Auth.auth().signOut()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Logout"), object: nil)
        }catch{
            print("error")
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
