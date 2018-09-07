//
//  LogoutRiderViewController.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 18/08/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
class LogoutRiderViewController: UITableViewController{
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var EmailAccount: UILabel!
    lazy var Name=String()
    lazy var snapshotUID=String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    func ShowDetail(){
        Database.database().reference().child("user").child(snapshotUID).observe(.value) { [weak self](data) in
            print(data)
            if let snap = data.value as? [String:Any]{
                print(snap)
                guard let name = snap["Name"] as? String else {return}
                print(name)
                self?.Name = name
                guard let Emailname = snap["email"] as? String else {return}
                self?.NameLabel.text = name
                self?.EmailAccount.text = Emailname
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
                                    if error != nil{
                                        print("Error in email")
                                    }else{
                                        Database.database().reference().child("user").child(self.snapshotUID).updateChildValues(["email":emaiasd])
                                        do{
                                            try Auth.auth().signOut()
                                            self.dismiss(animated: true, completion: nil)
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
                        //sdfsdfs
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
                                        //asdds
                                    }else{
                                        do{
                                            try Auth.auth().signOut()
                                            self.dismiss(animated: true)
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
    @IBAction func BacKTo(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Logout(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            let vc = UIStoryboard(name: "Rider1", bundle: nil).instantiateViewController(withIdentifier: "UIViewController-BYZ-38-t0r")
            self.dismiss(animated: true) {
                self.present(vc, animated: true, completion: nil)
            }
        }catch{
            
        }
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
}
