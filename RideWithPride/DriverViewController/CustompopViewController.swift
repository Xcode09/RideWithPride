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
    func AcceptRide(_ email:String)
    
   
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
        Database.database().reference().child("loaction").observe(.childAdded) { [weak self](data) in
            print(data)
            self?.list.append(data)
            self?.popview.reloadData()
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
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let snapshot = list[indexPath.row]
        if let snaps=snapshot.value as? [String:Any]{
            guard let ema = snaps["email"] as? String else {
                print("Not email")
                return UITableViewCell()
                
            }
            DispatchQueue.main.async { [weak self] in 
                cell.textLabel?.text = ema
                cell.detailTextLabel?.text = "Rider is \(String(describing: self?.distancess)) Km Away"
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
            let snapshot = self.list[indexPath.row]
            if let snaps=snapshot.value as? [String:Any]{
                guard let ema = snaps["email"] as? String else {
                    print("Not email")
                    return
                }
            self.delegate?.AcceptRide(ema)
            self.list.remove(at: indexPath.row)
            self.distance?.ShowDistance()
            tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        action.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
    }
    return UISwipeActionsConfiguration(actions: [action])

}
}
