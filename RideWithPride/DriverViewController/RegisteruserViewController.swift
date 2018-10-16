//
//  RegisteruserViewController.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 08/10/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreLocation
import FirebaseDatabase
import CoreTelephony

class RegisteruserViewController: UIViewController,CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var activtiycontroller: UIActivityIndicatorView!
    
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var phone: DesignTextfeild!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var password: DesignTextfeild!
    @IBOutlet weak var email: DesignTextfeild!
    @IBOutlet weak var Name: DesignTextfeild!
    @IBOutlet weak var scr :UIScrollView!
   
    private let EmailRegex = "\\w+\\d?\\@\\w+\\.com"
    private let iphone = "\\+\\d+"
    private let name = "\\w+"
    lazy var manager = CLLocationManager()
    var  loaction : CLLocation?
    lazy var array = [String]()
    lazy var vName=String()
    lazy var vColor=String()
    lazy var vNO=String()
    lazy var key = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        //ExtraThings.KeyboardManagement(top: top, cot: 20)
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
        manager.activityType = .automotiveNavigation
        manager.requestWhenInUseAuthorization()
        picker.delegate = self
        register.layer.cornerRadius = 26
        register.backgroundColor  = UIColor(cgColor: CGColor.colorForbtn())
        NotificationCenter.default.addObserver(forName: .name, object: nil, queue: OperationQueue.main) { (noti) in
            if let vname = noti.userInfo as? [String:Any]{
                self.vName = vname["vName"] as! String
                self.vColor = vname["vColor"] as! String
                self.vNO = vname["vNo"] as! String
            }else{
                print("not name")
            }
        
    }
    }
    override func viewWillAppear(_ animated: Bool) {
        AllCodesList.AllCodes { (dic) in
            
            let vc = dic["dial_code"] as! String
            self.array.append(vc)
            
            
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let  loon = locations.last else{return}
        loaction = loon
        
    }
    @IBAction func Register(_ sender:UIButton){
        activtiycontroller.startAnimating()
        register.isHidden = true
        loginfor()
    }
    @IBAction func cancle(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    private func loginfor(){
        guard let name = Name.text else{return}
        guard let phone = phone.text else{return}
        guard let Email = email.text else{return}
        
        let emailvalidate = createAccountRiderView.isEmailValide(EmailText: Email, regularExp: EmailRegex)
        let Namevalidate = createAccountRiderView.isEmailValide(EmailText: name, regularExp: EmailRegex)
        
        guard let pass = password.text else{return}
        if name != "" && name.count >= 3 && emailvalidate == true && pass != "" && pass.count >= 8 && Namevalidate == true{
            Auth.auth().createUser(withEmail: Email, password: pass) { [weak self](user, error) in
                if error != nil{
                    let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: String(describing: error?.localizedDescription))
                    self?.present(alert, animated: true, completion: nil)
                    self?.activtiycontroller.stopAnimating()
                    self?.register.isHidden = false
                }else{
                    Auth.auth().currentUser?.sendEmailVerification(completion: { (errror) in
                        if errror != nil{
                            let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: String(describing: error?.localizedDescription))
                            self?.present(alert, animated: true, completion: nil)
                            self?.activtiycontroller.stopAnimating()
                            self?.register.isHidden = false

                        }else{
                            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
                                self?.SaveRegisteration(with: user!, name: name, phone: phone, vName: (self?.vName)!, vNo: (self?.vNO)!, vColor: (self?.vColor)!)
                                self?.activtiycontroller.stopAnimating()
                                self?.dismiss(animated: true, completion: {
                                    NotificationCenter.default.post(name: .namex, object: nil)
                                })


                            }
                            
                        }
                    })
                }
            }
            
        } else if emailvalidate == false {
            let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: "email is not correct format")
            self.present(alert, animated: true, completion: nil)
            self.activtiycontroller.stopAnimating()
            self.register.isHidden = false
            
            
        } else if phone.count < 8 {
            let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: "password should contains 8 charaters")
            self.present(alert, animated: true, completion: nil)
            self.activtiycontroller.stopAnimating()
            self.register.isHidden = false
        } else if name.count < 3 || Namevalidate == false{
            let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: "Name must be more then 3  only characters")
            self.present(alert, animated: true, completion: nil)
            self.activtiycontroller.stopAnimating()
            self.register.isHidden = false
        }
        else{
            let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: "check Fields something is missing ")
            self.present(alert, animated: true, completion: nil)
            self.activtiycontroller.stopAnimating()
            self.register.isHidden = false
        }
        
    }
    private func SaveRegisteration(with user : User , name:String, phone:String,vName:String,vNo:String,vColor:String){
        let databaserefernce = Database.database().reference().child("DriverUser").child(user.uid)
        guard let email = user.email else{return}
        let lati : Double = (loaction?.coordinate.latitude)!
        let log : Double = (loaction?.coordinate.longitude)!
        let Values = ["Name":name,"email":email,"phone":dialcode + phone,"lati":lati,"log":log,"vName":vName,"vNo":vNO,"vColor":vColor] as [String : Any]
        databaserefernce.setValue(Values)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array.count
    }
    //    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    //        let vc = UIView(frame: CGRect(x: 0, y: 10, width: picker.frame.width, height: 100))
    //        let lb = UILabel(frame: CGRect(x: 0, y: 0, width: picker.frame.width, height: 50))
    //        lb.text = "Hello"
    //        lb.textAlignment = .center
    //        lb.textColor = .black
    //        vc.addSubview(lb)
    //
    //        return vc
    //    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return array[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    lazy var dialcode = String()
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        dialcode = array[row]
    }
   
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
extension RegisteruserViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scr.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        loginfor()
        return true
    }
}
