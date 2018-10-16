//
//  CustompopViewController.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 14/08/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
protocol RiderDelegate {
    func AcceptRide(_ name:String,_ phone:String,_ email:String,_ dremail:String,vN0:String,vColor:String?)
    
   
}
protocol Distance {
    func ShowDistance()
}
protocol AcceptRiders {
    func AlertTOrider()
}
class CustompopViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var popview : UITableView!
    @IBOutlet weak var activity : UIActivityIndicatorView!
    
    lazy var DriverLocation=CLLocationCoordinate2D()
    lazy var city = String()
    lazy var email = String()
    var list = [DataSnapshot]()
    var delegate:RiderDelegate?
    var distance:Distance?
    var acceptDelegate:AcceptRiders?
    lazy var distancess=Double()
    override func viewDidLoad() {
        super.viewDidLoad()
       popview.layer.cornerRadius = 10
        popview.layer.masksToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        
        activity.startAnimating()
        popview.layer.borderWidth = 2
        popview.layer.borderColor = UIColor.blue.cgColor
        Database.database().reference().child("loaction").observe(.childAdded) { [weak self](data) in
            if data.exists(){
                self?.list.append(data)
                self?.popview.reloadData()
            }else{
                self?.activity.stopAnimating()
                self?.popview.removeFromSuperview()

            }
        }
        Riders.AllRides(compilation: { [weak self](double, location) in
            self?.distancess = double
            
        }, DriverLocation: self.DriverLocation)
        
            self.popview.reloadData()
        
    }
    @IBAction func dissmiss(_ sender:UIButton){
        self.dismiss(animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if list.isEmpty{
            return 0
        }else{
            return list.count

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if list.isEmpty{
            activity.stopAnimating()
            self.dismiss(animated: true, completion: nil)
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let snapshot = list[indexPath.row]
        if let snaps=snapshot.value as? [String:Any]{
            guard let ema = snaps["email"] as? String else {
                print("Not email")
                return UITableViewCell()
                
            }
            guard let way = snaps["way"] as? String else {
                print("Not Found")
                return UITableViewCell()
            }
            
            DispatchQueue.main.async {
                
                cell.textLabel?.text = "Ride option \(way)"
                cell.detailTextLabel?.text = "Rider is \(self.distancess) Away"

            }
            activity.stopAnimating()
            
                self.email = ema
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Cancel a Accept") { (action, view, bool) in
            self.list.remove(at: indexPath.row)
            tableView.reloadData()
        }
      
        return UISwipeActionsConfiguration(actions: [action])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Accept Ride") { (action, view, bool) in
            guard let uid = Auth.auth().currentUser?.uid else {return}
            Database.database().reference().child("DriverUser").child(uid).observe(.value) { (data) in
                if let snap = data.value as? [String:Any]{
                    guard let phone = snap["phone"] as? String else{return}
                    guard let ema = snap["Name"] as? String else{return}
                    guard let dremail = snap["email"] as? String else{return}
                    guard let vno = snap["vNo"] as? String else{return}
                     guard let vcolor = snap["vColor"] as? String else{return}
                    self.delegate?.AcceptRide(ema,phone,self.email,dremail, vN0: vno, vColor: vcolor)
                }
                Database.database().reference().child("DriverUser").removeAllObservers()
            }
               
            
            self.list.remove(at: indexPath.row)
            self.distance?.ShowDistance()
            tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        action.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        return UISwipeActionsConfiguration(actions: [action])
    }
    

}
