//
//  DriverRegister.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 10/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class DriverRegister: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var CNIC: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phoneNO: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var lognbtn:UIButton!
    @IBOutlet weak var createbtn:UIButton!
    override func viewDidAppear(_ animated: Bool) {
      password.delegate = self
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { (noti) in
            guard let rect = noti.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue else{return}
            let recte = rect.cgRectValue
            if noti.name == NSNotification.Name.UIKeyboardWillShow{
                self.Email.frame.origin.y = -recte.height
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
     private let EmailRegex = "\\w+\\d?\\@\\w+\\.com"
    private let cnicregx = "\\d+"
    override func viewWillAppear(_ animated: Bool) {
        lognbtn.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        createbtn.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        lognbtn.layer.cornerRadius = 20
        createbtn.layer.cornerRadius = 20
        lognbtn.layer.contentsScale = 20
        createbtn.layer.contentsScale = 20
    }
    @IBAction func Resigter(_ sender: UIButton) {
       loginfor()
    }
    
    @IBAction func loginback(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
                    self.ErrorAlertShow(Title: "Error", Message: (error?.localizedDescription)!)
                }else{
                    self.SaveRegisteration(with: user!, name: name, cnic: cnic, address: adre, phone: phone)
                }
            }
            ErrorAlertShow(Title: "Complete", Message: "Great")
            
        }else if cnincvalidat == false || emailvalidate == false || isphone == false{
           ErrorAlertShow(Title: "Error", Message: "CNIC contains only No or Email is  Not correct format may be phoneNo  is  Not correct format ")
        }else{
            ErrorAlertShow(Title: "OOPS", Message: "Error")
        }
        
    }
    private func SaveRegisteration(with user : User , name:String ,cnic:String,address:String,phone:String){
        let databaserefernce = Database.database().reference().child("DriverUser").child(user.uid)
        guard let email = user.email else{return}
        let Values = ["Name":name,"email":email,"Cnic":cnic,"address":address,"phone":phone]
        databaserefernce.setValue(Values)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        loginfor()
        return true
    }
    func ErrorAlertShow(Title:String,Message:String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
