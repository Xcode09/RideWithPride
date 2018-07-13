//
//  createAccountRiderView.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 06/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class createAccountRiderView: UIViewController {
    @IBOutlet weak var Nametextfield:UITextField!
     @IBOutlet weak var Emailtextfield:UITextField!
     @IBOutlet weak var Passwordtextfield:UITextField!
    @IBOutlet weak var createbt : UIButton!
    
    // Mark : Regular Expression For email
    private let EmailRegex = "\\w+\\d?\\@\\w+\\.com"
    //Mark:Regular Expression for Password
    //private let passwordexp = "[A-Z0-9]{8}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createbt.layer.cornerRadius = 8
        createbt.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        Delegatesoftextfield()
        
    }

    
    /// Mark : Back To Login
    @IBAction func BackToLogin(_ sender:UIButton){
        let loginview = UIStoryboard(name: "Rider1", bundle: nil).instantiateViewController(withIdentifier: "UIViewController-BYZ-38-t0r")
        self.present(loginview, animated: true, completion: nil)
    }
    
    @IBAction func CreateAccount(_ sender:UIButton){
       CreataccountCheck()
    }
    /// Mark:Create account validation check function
    private func CreataccountCheck(){
        guard let text = Nametextfield.text else {return}
        guard let email = Emailtextfield.text else{return}
        guard let pass = Passwordtextfield.text else {return}
        let emailtrue = isEmailValide(EmailText: email)
        //let passwordtrue = isPasswordValide(PasswordText: pass)
        if text != "" && emailtrue == true && pass.count >= 8{
            Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
                if error != nil{
                    self.ErrorAlertShow(Title: "Error", Message: (error?.localizedDescription)!)
                }
                self.SaveInDatabase(with: user!, with: text)
                self.Cleartext()
                let callaridevc = UIStoryboard(name: "CreateAccount", bundle: nil).instantiateViewController(withIdentifier: "Callride")
                self.present(callaridevc, animated: true, completion: nil)
                
            }
        }
        else if emailtrue == false{
            ErrorAlertShow(Title: "Email Wrong", Message: "Please Enter information according to the format in placeholder.")
        }else if pass.count < 8{
            ErrorAlertShow(Title: "Password Wrong", Message: "password must 8 charaters......")
        }else if text == ""{
            ErrorAlertShow(Title: "Name Field Empty", Message: "Please fill your name")
        }else{
            ErrorAlertShow(Title: "SomeThingWrong", Message: "OOPs")
        }
        
    }
    private func SaveInDatabase(with user:User,with name :String){
        let databaserefernce = Database.database().reference().child("user").child(user.uid)
        guard let email = user.email else{return}
        let Values = ["Name":name,"email":email]
        databaserefernce.updateChildValues(Values) { (error, ref) in
            if error != nil{
                self.ErrorAlertShow(Title: "Error", Message: (error?.localizedDescription)!)
            }
            self.ErrorAlertShow(Title: "Saved", Message: "Save in firebase database")
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}


extension createAccountRiderView:UITextFieldDelegate{
    fileprivate func Delegatesoftextfield(){
        Nametextfield.delegate = self
        Emailtextfield.delegate = self
        Passwordtextfield.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        CreataccountCheck()
        return true
    }
}
extension createAccountRiderView{
    fileprivate func isEmailValide(EmailText:String?)->Bool{
        guard EmailText != nil else {return false}
        let regexp = NSPredicate(format: "SELF MATCHES %@",EmailRegex)
        return regexp.evaluate(with:EmailText)
    }
    func Cleartext(){
        Nametextfield.text = ""
        Emailtextfield.text = ""
        Passwordtextfield.text = ""
    }
 func ErrorAlertShow(Title:String,Message:String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
