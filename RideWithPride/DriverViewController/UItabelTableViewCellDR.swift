//
//  UItabelTableViewCellDR.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 13/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation
protocol alerts: class {
    func presentAlert(title:String, message:String)
    func BacktoLogin()
    func presentStoryboard()
    func showactivity()
}
class UItabelTableViewCellDR: UITableViewCell,CLLocationManagerDelegate {
    @IBOutlet weak var Name: UITextField!
        @IBOutlet weak var CNIC: UITextField!
        @IBOutlet weak var address: UITextField!
        @IBOutlet weak var phoneNO: UITextField!
        @IBOutlet weak var Email: UITextField!
        @IBOutlet weak var password: UITextField!
        @IBOutlet weak var lognbtn:UIButton!
        @IBOutlet weak var createbtn:UIButton!
   
    
    private let EmailRegex = "\\w+\\d?\\@\\w+\\.com"
    private let cnicregx = "\\d+"
    var delegate : alerts?
    var istrue = false
    lazy var manager = CLLocationManager()
    var  loaction : CLLocation?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        manager.delegate = self
        lognbtn.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        createbtn.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        lognbtn.layer.cornerRadius = 20
        createbtn.layer.cornerRadius = 20
        lognbtn.layer.contentsScale = 20
        createbtn.layer.contentsScale = 20
       
    }
    
    
    @IBAction func Registerion(_ sender:Any){
        loginfor()
        manager.startUpdatingLocation()
        delegate?.showactivity()
        
    }
    @IBAction func backtologin(_ sender:Any){
        manager.stopUpdatingLocation()
        delegate?.BacktoLogin()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let  loon = locations.last else{return}
        loaction = loon
        
    }
    
    private func loginfor(){
                guard let name = Name.text else{return}
                guard let cnic = CNIC.text else{return}
                guard let adre = address.text else{return}
                guard let phone = phoneNO.text else{return}
                guard let Email = Email.text else{return}
                let emailvalidate = createAccountRiderView.isEmailValide(EmailText: Email, regularExp: EmailRegex)
                let cnincvalidat = createAccountRiderView.isEmailValide(EmailText: cnic, regularExp: cnicregx)
                let isphone = createAccountRiderView.isEmailValide(EmailText: phone, regularExp: cnicregx)
                guard let pass = password.text else{return}
                if name != "" && cnincvalidat == true && adre != "" && isphone == true && emailvalidate == true && pass != "" {
                    Auth.auth().createUser(withEmail: Email, password: pass) { (user, error) in
                        if error != nil{
                            self.delegate?.presentAlert(title: "Error", message: (error?.localizedDescription)!)
                            
                        }else{
                Auth.auth().currentUser?.sendEmailVerification(completion: { (errror) in
                                if errror != nil{
                                    print("error")
                                }else{
                                    self.SaveRegisteration(with: user!, name: name, cnic: cnic, address: adre, phone: phone)
                                    self.delegate?.presentStoryboard()
                            
                                    self.istrue = true
                                    
                                }
                            })
                        }
                    }
        
                }else if cnincvalidat == false || emailvalidate == false || isphone == false{
                    
                   delegate?.presentAlert(title: "Error", message: "CNIC contains only No or Email is  Not correct format may be phoneNo  is  Not correct format ")
                    
                    
                }else{
                    delegate?.presentAlert(title: "Error", message: "Something worng")
                    
                }
        
        }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
        private func SaveRegisteration(with user : User , name:String ,cnic:String,address:String,phone:String){
            let databaserefernce = Database.database().reference().child("DriverUser").child(user.uid)
            guard let email = user.email else{return}
            let lati : Double = (loaction?.coordinate.latitude)!
            let log : Double = (loaction?.coordinate.longitude)!
            let Values = ["Name":name,"email":email,"Cnic":cnic,"address":address,"phone":phone,"lati":lati,"log":log] as [String : Any]
            databaserefernce.setValue(Values)
    }
}
