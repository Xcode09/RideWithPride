//
//  DriverLoginViewController.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 10/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
class DriverLoginViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var emailtextfield:UITextField!
    @IBOutlet weak var Passwordtextfield:UITextField!
     @IBOutlet weak var logn:UIButton!
     @IBOutlet weak var createbtin:UIButton!
    @IBOutlet weak var activity : UIActivityIndicatorView!
    @IBOutlet weak var stackview : UIStackView!
    
    var vc : UIViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewDidLoadthings()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func Login(_ sender:UIButton){
        login()
    }
    @IBAction func resigter(_ sender:UIButton ){
        self.dismiss(animated: true, completion: nil)
            
    }
    private func login(){
        activity.startAnimating()
        activity.isHidden = false
        guard let email = emailtextfield.text else {return}
        guard let password = Passwordtextfield.text else{return}
        if email != "" && password != ""{
            guard let ver = Auth.auth().currentUser?.isEmailVerified else {
                let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: "User is not found or Not verfied")
                self.present(alert, animated: true, completion: nil)
                activity.stopAnimating()
                activity.isHidden = true
                return
            }
            if ver {
                SignUi(email: email, password: password)
            }else{
                let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: "Email is not verified")
                self.present(alert, animated: true, completion: nil)
                activity.stopAnimating()
                activity.isHidden = true
            }
        }else{
           let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: "Fields Are Empty......")
            self.present(alert, animated: true, completion: nil)
            activity.stopAnimating()
            activity.isHidden = true
        }
    }
    private func SignUi(email:String,password:String){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: (error?.localizedDescription)!)
                self.present(alert, animated: true, completion: nil)
                self.activity.stopAnimating()
                self.activity.isHidden = true
            }else {
                let vc = UIStoryboard(name: "DriverControlPanel", bundle: nil).instantiateViewController(withIdentifier: "DR")
                self.activity.stopAnimating()
                self.activity.isHidden = true
                self.present(vc, animated: true)
            }
            
        }
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
    @IBAction func BackToMain(_ sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)

    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        login()
        return true
    }
    fileprivate func ViewDidLoadthings() {
        self.emailtextfield.delegate = self
        self.Passwordtextfield.delegate = self
        emailtextfield.SetImage(imageName: "profile")
        Passwordtextfield.SetImage(imageName: "key")
         KeyboardManagement()
        activity?.isHidden = true
        logn.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        createbtin.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        logn.layer.contentsScale = 10
        logn.layer.cornerRadius = 10
        createbtin.layer.contentsScale = 10
        createbtin.layer.cornerRadius = 10
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
}
