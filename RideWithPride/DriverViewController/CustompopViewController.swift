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
    func Cancelride()
}
protocol Distance {
    func ShowDistance()
}
class CustompopViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var popview : UITableView!
    lazy var DriverLocation=CLLocationCoordinate2D()
    lazy var city = String()
    lazy var email = String()
    var list = [DataSnapshot]()
    var delegate:RiderDelegate?
    var distance:Distance?
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("loaction").observe(.childAdded) { (data) in
            self.list.append(data)
            self.popview.reloadData()
        }
       popview.layer.cornerRadius = 10
        popview.layer.masksToBounds = true
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
            
            cell.textLabel?.text = ema
            print(ema)
            email = ema
            Riders.AllRides(compilation: { (double, location) in
                cell.detailTextLabel?.text = "\(double)Location is \(self.city)"
            }, DriverLocation: DriverLocation)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Cancel a Accept") { (action, view, bool) in
            self.delegate?.Cancelride()
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
            self.distance?.ShowDistance()
            self.dismiss(animated: true, completion: nil)
        }
        action.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
    }
    return UISwipeActionsConfiguration(actions: [action])

}
}
