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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Delegates
        self.emailtextfield.delegate = self
        self.Passwordtextfield.delegate = self
        activity?.isHidden = true
        createbuttons.layer.cornerRadius = 10
        createbuttons.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        logbuttons.layer.cornerRadius = 10
        
    }
    override func viewWillAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser?.email
        print(user)
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
            
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error != nil{
                    self.ErrorAlertShow(Title: "Error", Message: (error?.localizedDescription)!)
                    self.activity.stopAnimating()
                    self.activity.isHidden = true
                    
                }else {
                    self.activity.stopAnimating()
                    self.activity.isHidden = true
                    ExtraThings.Cleartext(NameField: self.emailtextfield,passwordfiled: self.Passwordtextfield)
                    // Navigate to Main RidePanel
                    let callaride = UIStoryboard(name: "CreateAccount", bundle: nil).instantiateViewController(withIdentifier: "Callride")
                    self.present(callaride, animated: true, completion: nil)
                }
                
            }
        }else{
          ErrorAlertShow(Title: "OOPS", Message: "Wrong Email or Password")
            activity.stopAnimating()
            ExtraThings.Cleartext(NameField: self.emailtextfield,passwordfiled: self.Passwordtextfield)
            activity.isHidden = true
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
    func ErrorAlertShow(Title:String,Message:String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

