//
//  TableViewController.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 13/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ConstrainstonActivity()
    }
    var Celltrue:Bool?
    var vc : UIViewController?
    lazy var activitiy : UIActivityIndicatorView = {
        var activty = UIActivityIndicatorView()
        activty.activityIndicatorViewStyle = .whiteLarge
        activty.isHidden = true
        activty.backgroundColor = .red
        activty.translatesAutoresizingMaskIntoConstraints=false
        return activty
    }()
    private func ConstrainstonActivity(){
        tableView.insertSubview(activitiy, aboveSubview: tableView)
        activitiy.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive=true
        activitiy.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive=true
        activitiy.widthAnchor.constraint(equalToConstant: 60).isActive=true
        activitiy.heightAnchor.constraint(equalToConstant: 60).isActive=true
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UItabelTableViewCellDR
        cell.delegate = self
        Celltrue = cell.istrue
        print(Celltrue!)
        return cell
    }
    

    
}
extension TableViewController:alerts{
    
    func BacktoLogin() {
        dismiss(animated: true, completion: nil)
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (alert) in
            self.activitiy.isHidden = true
            self.activitiy.stopAnimating()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func presentStoryboard(ViewController: UIViewController) {
        dismiss(animated: true) {
            self.vc = ViewController
            self.perform(#selector(self.Navigatie), with: nil, afterDelay: 2)
            
        }
    }
    @objc func Navigatie(){
        self.present(vc!, animated: true, completion: nil)
    }
    func showactivity() {
        if Celltrue == false{
            activitiy.isHidden = false
            activitiy.startAnimating()
        }else{
            activitiy.isHidden = true
            activitiy.stopAnimating()
        }
        
        
    }
    
    
}
extension TableViewController{
    
}
