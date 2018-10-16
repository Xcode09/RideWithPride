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
       
        if UserDefaults.standard.bool(forKey: "issignin") == true{
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { (time) in
                self.activity.startAnimating()
                let callaride = UIStoryboard(name: "CreateAccount", bundle: nil).instantiateViewController(withIdentifier: "NaviRide")
                self.present(callaride, animated: true, completion: {
                    self.activity.stopAnimating()
                })
            }
        }
         // Delegates
        self.Passwordtextfield.delegate = self
        activity?.isHidden = true
        createbuttons.layer.cornerRadius = 15
        createbuttons.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        logbuttons.layer.cornerRadius = 22
        logbuttons.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        //ResetPassbuttons.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        ResetPassbuttons.layer.cornerRadius = 10
        emailtextfield.attributedPlaceholder =  NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        Passwordtextfield.attributedPlaceholder =  NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black])
        
    }
    override func viewWillAppear(_ animated: Bool) {
    
        createbuttons.layer.cornerRadius = 20
        createbuttons.layer.masksToBounds = true
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
        logbuttons.isHidden = true
        guard let email = emailtextfield.text else {return}
        guard let password = Passwordtextfield.text else{return}
        if email != "" && password != ""{
            // Authentication with Firebase
            SignI(email: email, password: password)
       
        }else{
            ErrorAlertShow(Title: "OOPS", Message: "Wrong Email or Password")
            activity.stopAnimating()
            ExtraThings.Cleartext(NameField: self.emailtextfield,passwordfiled: self.Passwordtextfield)
            activity.isHidden = true
            logbuttons.isHidden = false
        }
    }
    private func SignI(email:String,password:String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                self.ErrorAlertShow(Title: "Error", Message: (error?.localizedDescription)!)
                self.activity.stopAnimating()
                self.activity.isHidden = true
                self.logbuttons.isHidden = false
                
            }else if user?.isEmailVerified == true{
                self.activity.stopAnimating()
                self.activity.isHidden = true
                self.logbuttons.isHidden = false
                ExtraThings.Cleartext(NameField: self.emailtextfield,passwordfiled: self.Passwordtextfield)
                // Navigate to Main RidePanel
                let callaride = UIStoryboard(name: "CreateAccount", bundle: nil).instantiateViewController(withIdentifier: "NaviRide")
                self.present(callaride, animated: true, completion: nil)
            }
            else{
                let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message:"Email is not verified")
                alert.addAction(UIAlertAction(title: "Resend Email verification link", style: .default, handler: { (ac) in
                    user?.sendEmailVerification(completion: { (error) in
                        if error != nil {
                            return
                        }else {
                            let alert = ExtraThings.ErrorAlertShow(Title: "Send", Message:"Email is Send")
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }))
                self.activity.isHidden=true
                self.logbuttons.isHidden=false
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

