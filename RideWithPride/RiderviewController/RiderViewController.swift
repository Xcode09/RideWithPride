//
//  ViewController.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 04/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
class RiderViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var emailtextfield:UITextField!
    @IBOutlet weak var Passwordtextfield:UITextField!
    @IBOutlet weak var activity : UIActivityIndicatorView!
    @IBOutlet weak var createbuttons : UIButton!
    @IBOutlet weak var logbuttons : UIButton!
    @IBOutlet weak var ResetPassbuttons : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegates
        self.emailtextfield.delegate = self
        emailtextfield.SetImage(imageName: "profile")
        self.Passwordtextfield.delegate = self
        Passwordtextfield.SetImage(imageName: "key")
        activity?.isHidden = true
        createbuttons.layer.cornerRadius = 5
        createbuttons.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        logbuttons.layer.cornerRadius = 10
        logbuttons.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        ResetPassbuttons.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        ResetPassbuttons.layer.cornerRadius = 10
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser?.email
        print(user)
        //Auth.auth().currentUser?.reload()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func Login(_ sender:UIButton){
        login()
        
    }
    private func login(){
        activity.startAnimating()
        activity.isHidden = false
        guard let email = emailtextfield.text else {return}
        guard let password = Passwordtextfield.text else{return}
        if email != "" && password != ""{
            // Authentication with Firebase
            guard let verified = Auth.auth().currentUser?.isEmailVerified else {
                ErrorAlertShow(Title: "Error ", Message: "User is Not found")
                activity.stopAnimating()
                activity.isHidden = true
                return
                
            }
            print(verified)
            if verified{
                SignI(email: email, password: password)
            }else{
                ErrorAlertShow(Title: "OOPS", Message: "Email is not verfied")
                activity.stopAnimating()
                ExtraThings.Cleartext(NameField: self.emailtextfield,passwordfiled: self.Passwordtextfield)
                activity.isHidden = true
         
        }
       
        }else{
            ErrorAlertShow(Title: "OOPS", Message: "Wrong Email or Password")
            activity.stopAnimating()
            ExtraThings.Cleartext(NameField: self.emailtextfield,passwordfiled: self.Passwordtextfield)
            activity.isHidden = true
        }
    }
    private func SignI(email:String,password:String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                self.ErrorAlertShow(Title: "Error", Message: (error?.localizedDescription)!)
                self.activity.stopAnimating()
                self.activity.isHidden = true
                
            }else{
                self.activity.stopAnimating()
                self.activity.isHidden = true
                ExtraThings.Cleartext(NameField: self.emailtextfield,passwordfiled: self.Passwordtextfield)
                // Navigate to Main RidePanel
                let callaride = UIStoryboard(name: "CreateAccount", bundle: nil).instantiateViewController(withIdentifier: "Callride")
                self.present(callaride, animated: true, completion: nil)
            }
            
        }
    }
    @IBAction func BackToMain(_ sender: UIBarButtonItem){
        dismiss(animated: true) {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainID")
            self.present(vc, animated: true)
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        login()
        return true
    }
    @IBAction func ResetPass(_ sender:UIButton){
        let alett = ExtraThings.ErrorAlertShow(Title: "Forgot Password", Message: "Forgot Password please enter Email")
        alett.addTextField { (text) in
            text.placeholder = "Email"
            
        }
        alett.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action) in
            let text = alett.textFields![0]
            if text.text != nil , let te = text.text{
                Auth.auth().sendPasswordReset(withEmail: te) { (error) in
                    if error != nil{
                        print("errro")
                    }else{
                        let alett = ExtraThings.ErrorAlertShow(Title: "OK", Message: "Link is send to that email")
                        self.present(alett, animated: true, completion: nil)
                    }
                }
            }
        }))
       self.present(alett, animated: true, completion: nil)
    }
    func ErrorAlertShow(Title:String,Message:String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

