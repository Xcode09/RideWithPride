//
//  DriverLogoutTableViewController.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 20/08/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class DriverLogoutTableViewController: UITableViewController {
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var EmailAccount: UILabel!
    @IBOutlet weak var nav : UINavigationBar!
    lazy var Name=String()
    lazy var snapshotUID=String()
    lazy var Cnic = String()
    lazy var address = String()
    lazy var phone = String()
    lazy var lati = Double()
    lazy var log = Double()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDiD")
        print(snapshotUID)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ShowDetail()
        print("view will")
        
        
    }
    func ShowDetail(){
        Database.database().reference().child("DriverUser").child(snapshotUID).observe(.value) { (data) in
            print(data)
            if let snap = data.value as? [String:Any]{
                print(snap)
                guard let name = snap["Name"] as? String else {return}
                print(name)
                self.Name = name
                guard let Emailname = snap["email"] as? String else {return}
                guard let Cnic = snap["Cnic"] as? String else {return}
                guard let address = snap["address"] as? String else {return}
                guard let phone = snap["phone"] as? String else {return}
                guard let lati = snap["lati"] as? Double else {return}
                guard let log = snap["log"] as? Double else {return}
                self.Cnic = Cnic
                self.address = address
                self.phone = phone
                self.lati = lati
                self.log  = log
                
                self.NameLabel.text = self.Name
                self.EmailAccount.text = Emailname
            }else{
                print("Not Data")
            }
        }
        
    }
    
    @IBAction func UpdateEmail(_ sender: UIButton) {
        let alert = ExtraThings.ErrorAlertShow(Title: "Login", Message: "Please Login again for Email update")
        alert.addTextField { (textem) in
            textem.placeholder = "Email"
        }
        alert.addTextField { (textem) in
            textem.placeholder = "Password"
            textem.isSecureTextEntry = true
            
        }
        alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { (action) in
            let emailtext = alert.textFields![0]
            let passtext = alert.textFields![1]
            if emailtext.text != "" && passtext.text != ""{
                guard let email = emailtext.text , let pass = passtext.text else{return}
                let user = Auth.auth().currentUser
                let credie = EmailAuthProvider.credential(withEmail: email, password: pass)
                user?.reauthenticate(with: credie, completion: { (error) in
                    if error != nil{
                        let error = ExtraThings.ErrorAlertShow(Title: "Error", Message: String(describing: error?.localizedDescription))
                        self.present(error, animated: true, completion: nil)
                    }else{
                        let updat = ExtraThings.ErrorAlertShow(Title: "New Email", Message: "please Entre New Email")
                        updat.addTextField(configurationHandler: { (text) in
                            text.placeholder = "Email"
                        })
                        updat.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
                            let emailtet = updat.textFields![0]
                            guard let emaiasd = emailtet.text else{return}
                            if emaiasd != ""{
                                user?.updateEmail(to:emaiasd , completion: { (error) in
                                    if let er = error{
                                        let error = ExtraThings.ErrorAlertShow(Title: "Error", Message: String(describing: er.localizedDescription))
                                        self.present(error, animated: true, completion: nil)                                    }else{
                                        Database.database().reference().child("DriverUser").child(self.snapshotUID).updateChildValues(["email":emaiasd])
                                        do{
                                            try Auth.auth().signOut()
                                            self.InitiateVC()
                                        }catch{
                                            print("Erroro zmc ")
                                        }
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                })
                            }
                        }))
                        self.present(updat, animated: true, completion: nil)
                    }
                })
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        let alert = ExtraThings.ErrorAlertShow(Title: "Login", Message: "Please Login again for password update")
        alert.addTextField { (textem) in
            textem.placeholder = "Email"
        }
        alert.addTextField { (textem) in
            textem.placeholder = "Password"
            textem.isSecureTextEntry = true
            
        }
        alert.addAction(UIAlertAction(title: "update", style: .default, handler: { (action) in
            let emailtext = alert.textFields![0]
            let passtext = alert.textFields![1]
            if emailtext.text != "" && passtext.text != ""{
                guard let email = emailtext.text , let pass = passtext.text else{return}
                let user = Auth.auth().currentUser
                let credie = EmailAuthProvider.credential(withEmail: email, password: pass)
                user?.reauthenticate(with: credie, completion: { (error) in
                    if error != nil {
                        let error = ExtraThings.ErrorAlertShow(Title: "Error", Message: String(describing: error?.localizedDescription))
                        self.present(error, animated: true, completion: nil)
                    }else{
                        let updat = ExtraThings.ErrorAlertShow(Title: "New PassWord", Message: "please Entre New password")
                        updat.addTextField(configurationHandler: { (text) in
                            text.placeholder = "New password"
                            text.isSecureTextEntry =  true
                        })
                        updat.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
                            let passtex = updat.textFields![0]
                            if passtex.text != ""{
                                guard let passs = passtex.text else {return}
                                user?.updatePassword(to: passs, completion: { (error) in
                                    if error != nil{
                                        let error = ExtraThings.ErrorAlertShow(Title: "Error", Message: String(describing: error?.localizedDescription))
                                        self.present(error, animated: true, completion: nil)
                                    }else{
                                        do{
                                            try Auth.auth().signOut()
                                            self.InitiateVC()
                                        }catch{
                                            print("asdasdsdasdas")
                                        }
                                    }
                                })
                            }
                        }))
                        self.present(updat, animated: true, completion: nil)
                    }
                })
            }
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    func InitiateVC(){
        let vc = UIStoryboard(name: "DriverLogin", bundle: nil).instantiateViewController(withIdentifier: "Lo")
        
        self.dismiss(animated: true, completion: {
            self.present(vc, animated: true, completion: nil)
    })
    }
    @IBAction func BacKTo(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Logout(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
          InitiateVC()
        }catch{
            
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    
    
}