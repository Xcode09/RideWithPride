//
//  RegisterViewController.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 07/10/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import CoreTelephony
import FirebaseDatabase
class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var Next: UIButton!
    @IBOutlet weak var lg: UIButton!
    @IBOutlet weak var vNo: UITextField!
    @IBOutlet weak var vColor: UITextField!
    @IBOutlet weak var vName: UITextField!
    private let vehcileRegc = "\\w+"
    private let vehcileNoRegx = "\\w+\\-\\d+"
    private let vehcilecolor = "\\w+"
    override func viewDidLoad() {
        super.viewDidLoad()
        ExtraThings.KeyboardManagement(top: top, cot: 0)
        vNo.delegate = self
        Next.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        Next.layer.cornerRadius = 26
        NotificationCenter.default.addObserver(forName: .namex, object: nil, queue: OperationQueue.main) { (noti) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func countine(_ sender:UIButton){
        next()
    }
    @IBAction func back(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }
   
    
    func next(){
        guard let Vn = vName.text else {return}
        guard let vcolor = vColor.text else {return}
        guard let vno = vNo.text else {return}
        let vNae = createAccountRiderView.isEmailValide(EmailText: Vn, regularExp: vehcileRegc)
        let vnO = createAccountRiderView.isEmailValide(EmailText: vno, regularExp: vehcileNoRegx)
        let vco = createAccountRiderView.isEmailValide(EmailText: vcolor, regularExp: vehcilecolor)
        if Vn.count >= 3 && vcolor.count >= 3 && vno.count > 3 && vNae==true
            && vnO==true  && vco==true{
            let vc = UIStoryboard(name: "DriverLogin", bundle: nil).instantiateViewController(withIdentifier: "w")
            present(vc, animated: true) {
                NotificationCenter.default.post(name: .name, object: self, userInfo: ["vName":Vn,"vColor":vcolor,"vNo":vno])
            }
            
            
        } else if vNae==false{
            let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: "Vehicle Name only contains words")
            present(alert, animated: true, completion: nil)
        }
            else if vnO==false{
            let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: "Vehcile No Format is not correct")
            present(alert, animated: true, completion: nil)
        }
            else if vco==false{
            let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: "Vehicle color only contains words")
            present(alert, animated: true, completion: nil)
        }
            
        else{
            let alert = ExtraThings.ErrorAlertShow(Title: "Error", Message: "Fields are Empty or Fields must contain 3  charaters ")
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        next()
        textField.resignFirstResponder()
        return true
    }

}
extension NSNotification.Name{
    static let name = NSNotification.Name(rawValue: "User")
    static let namex = NSNotification.Name(rawValue: "back")
}
