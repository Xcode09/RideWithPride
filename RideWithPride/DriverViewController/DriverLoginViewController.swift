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
        }else{
           let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: "Fields Are Empty......")
            self.present(alert, animated: true, completion: nil)
            activity.stopAnimating()
            activity.isHidden = true
        }
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
         KeyboardManagement()
        if Auth.auth().currentUser != nil {
            perform(#selector(navigatevc), with: self, afterDelay: 0.3)
        }
        activity?.isHidden = true
        logn.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        createbtin.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        logn.layer.contentsScale = 10
        logn.layer.cornerRadius = 10
        createbtin.layer.contentsScale = 10
        createbtin.layer.cornerRadius = 10
    }
    @objc func navigatevc(){
        let vc = UIStoryboard(name: "DriverControlPanel", bundle: nil).instantiateViewController(withIdentifier: "DR")
        self.present(vc, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
}
