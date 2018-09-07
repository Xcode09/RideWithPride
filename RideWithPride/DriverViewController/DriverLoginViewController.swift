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
        emailtextfield.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        Passwordtextfield.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        ViewDidLoadthings()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func Login(_ sender:UIButton){
        login()
        emailtextfield.text = ""
        Passwordtextfield.text = ""
    }
    @IBAction func resigter(_ sender:UIButton ){
        self.dismiss(animated: true, completion: nil)
            
    }
    private func login(){
        activity.startAnimating()
        activity.isHidden = false
        self.logn.isHidden = true
        guard let email = emailtextfield.text else {return}
        guard let password = Passwordtextfield.text else{return}
        if email != "" && password != ""{
            SignUi(email: email, password: password)
        }else{
           let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: "Fields Are Empty......")
            self.present(alert, animated: true, completion: nil)
            activity.stopAnimating()
            activity.isHidden = true
            self.logn.isHidden = false
        }
    }
    private func SignUi(email:String,password:String){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self](user, error) in
            if error != nil{
                let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: (error?.localizedDescription)!)
                self?.present(alert, animated: true, completion: nil)
                self?.activity.stopAnimating()
                self?.activity.isHidden = true
                self?.logn.isHidden = false
            }else if user?.isEmailVerified == true{
                let vc = UIStoryboard(name: "DriverControlPanel", bundle: nil).instantiateViewController(withIdentifier: "NaviDr")
                self?.activity.stopAnimating()
                self?.activity.isHidden = true
                self?.logn.isHidden = false
                self?.present(vc, animated: true)
            }else{
                let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message:"Email is not verified")
                alert.addAction(UIAlertAction(title: "Resend Email verification link", style: .default, handler: { (ac) in
                    user?.sendEmailVerification(completion: { (error) in
                        if error != nil {
                            return
                        }else {
                            let alert = ExtraThings.ErrorAlertShow(Title: "Send", Message:"Email is Send")
                            self?.present(alert, animated: true, completion: nil)
                        }
                    })
                }))
                self?.present(alert, animated: true, completion: nil)
                self?.activity.stopAnimating()
                self?.activity.isHidden = true
                self?.logn.isHidden = false

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
                Auth.auth().sendPasswordReset(withEmail: te) {  [weak self](error) in
                    if error != nil{
                        print("errro")
                    }else{
                        let alett = ExtraThings.ErrorAlertShow(Title: "OK", Message: "Link is send to that email")
                        self?.present(alett, animated: true, completion: nil)
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
        self.Passwordtextfield.delegate = self
         KeyboardManagement()
        activity?.isHidden = true
        logn.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        createbtin.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        logn.layer.contentsScale = 10
        logn.layer.cornerRadius = 30
        createbtin.layer.contentsScale = 10
        createbtin.layer.cornerRadius = 30
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
}
