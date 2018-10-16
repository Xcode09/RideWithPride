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
    
    
    @IBOutlet weak var versionlb: UILabel!
    lazy var Name=String()
    lazy var snapshotUID=String()
    lazy var Cnic = String()
    lazy var address = String()
    lazy var phone = String()
    lazy var lati = Double()
    lazy var log = Double()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let lb = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String{
            self.versionlb.text = lb
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        ShowDetail()
        
        
    }
    func ShowDetail(){
        Database.database().reference().child("DriverUser").child(snapshotUID).observe(.value) { [weak self](data) in
            print(data)
            if let snap = data.value as? [String:Any]{
                print(snap)
                guard let name = snap["Name"] as? String else {return}
                self?.Name = name
                guard var Emailname = snap["email"] as? String else {return}
                guard let phone = snap["phone"] as? String else {return}
                guard let lati = snap["lati"] as? Double else {return}
                guard let log = snap["log"] as? Double else {return}
                self?.phone = phone
                self?.lati = lati
                self?.log  = log
                if InternetCheck.Isinternetavailbe() == false {
                    self?.Name = "Not internet Connection"
                    Emailname = "Not internet Connection"
                }
                self?.NameLabel.text = self?.Name ?? "Not internet Connection"
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
                user?.reauthenticate(with: credie, completion: { [weak self] (error) in
                    if error != nil{
                        let error = ExtraThings.ErrorAlertShow(Title: "Error", Message: String(describing: error?.localizedDescription))
                        self?.present(error, animated: true, completion: nil)
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
                                        self?.present(error, animated: true, completion: nil)                                    }else{
                                        Database.database().reference().child("DriverUser").child((self?.snapshotUID)!).updateChildValues(["email":emaiasd])
                                        do{
                                            try Auth.auth().signOut()
                                            self?.InitiateVC()
                                        }catch{
                                            print("Erroro zmc ")
                                        }
                                        self?.dismiss(animated: true, completion: nil)
                                    }
                                })
                            }
                        }))
                        self?.present(updat, animated: true, completion: nil)
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
        let sheet = UIAlertController(title: "LogOut", message: "Are you sure to logout", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "OK", style: .default, handler: { (ac) in
            do{
                try Auth.auth().signOut()
                self.InitiateVC()
            }catch{
                
            }
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet, animated: true, completion: nil)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .white
            headerView.textLabel?.textColor = .gray
            headerView.textLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        }
    }
    
    @IBAction func AccountDel(_ sender:UIButton){
        let sheet = UIAlertController(title: "Delete Account", message: "it will Delete all your data are you sure", preferredStyle: .alert)
        sheet.addAction(UIAlertAction(title: "OK", style: .default, handler: { (ac) in
            Auth.auth().currentUser?.delete(completion: { (error) in
                if error != nil{
                    print(error?.localizedDescription)
                }else{
                    Database.database().reference().child("DriverUser").child(self.snapshotUID).observe(.value, with: { (data) in
                        data.ref.removeValue()
                        Database.database().reference().child("DriverUser").child(self.snapshotUID).removeAllObservers()
                        let del = UIAlertController(title: "Account Deleted", message: "Account is deleted successfully", preferredStyle: .actionSheet)
                        del.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                            do{
                                try Auth.auth().signOut()
                                self.InitiateVC()
                            }catch{
                                
                            }
                        }))
                        self.present(del, animated: true, completion: nil)
                    })
                }
            })
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet, animated: true, completion: nil)
        
    }
    
}
