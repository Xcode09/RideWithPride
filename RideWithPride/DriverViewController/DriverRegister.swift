//
//  DriverRegister.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 10/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit

class DriverRegister: UIViewController {
    @IBOutlet weak var Name: UITextField!
    @IBOutlet weak var CNIC: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phoneNO: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var lognbtn:UIButton!
    @IBOutlet weak var createbtn:UIButton!
    override func viewDidAppear(_ animated: Bool) {
        
    }
     private let EmailRegex = "\\w+\\d?\\@\\w+\\.com"
    override func viewWillAppear(_ animated: Bool) {
        lognbtn.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        createbtn.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        lognbtn.layer.cornerRadius = 20
        createbtn.layer.cornerRadius = 20
        lognbtn.layer.contentsScale = 20
        createbtn.layer.contentsScale = 20
    }
    @IBAction func Resigter(_ sender: UIButton) {
       
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
        let emailvalidate = isEmailValide(EmailText: Email)
        guard let pass = password.text else{return}
        if name != "" && cnic != "" && adre != "" && phone != "" && emailvalidate == true && pass != "" {
            
        }else{
            ErrorAlertShow(Title: "Error", Message: "Erro please chek")
        }
        
    }
    fileprivate func isEmailValide(EmailText:String?)->Bool{
        guard EmailText != nil else {return false}
        let regexp = NSPredicate(format: "SELF MATCHES %@",EmailRegex)
        return regexp.evaluate(with:EmailText)
    }
    func ErrorAlertShow(Title:String,Message:String){
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
