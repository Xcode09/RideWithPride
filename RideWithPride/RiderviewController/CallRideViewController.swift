//
//  CallRideViewController.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 09/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase
class CallRideViewController: UIViewController,CLLocationManagerDelegate {
    //@IBOutlet weak var map:MKMapView!
    @IBOutlet weak var Sideview : UIView!
    @IBOutlet weak var layout : NSLayoutConstraint!
    @IBOutlet weak var SideBaremail: UILabel!
    @IBOutlet weak var stack : UIStackView!
    //@IBOutlet weak var labelshow: UILabel!
    
    /// Mark: properties
    var userloaction : CLLocationCoordinate2D?
    var LocationManager = CLLocationManager()
    var CancleRide:Bool=false
    lazy var map:MKMapView={
        var map = MKMapView()
        map.showsCompass = true
        map.isScrollEnabled = true
        map.showsBuildings = true
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints=false
        return map
    }()
    lazy var viewshow : UIView = {
        var view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints=false
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.insertSubview(map, at: 0)
        self.view.addSubview(viewshow)
        map.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        map.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        map.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        map.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        viewshow.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        viewshow.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        viewshow.topAnchor.constraint(equalTo: view.topAnchor , constant:16).isActive=true
        viewshow.widthAnchor.constraint(equalToConstant: view.frame.width).isActive=true
        viewshow.heightAnchor.constraint(equalToConstant: 30).isActive=true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        setLoation()
    }
    private func setLoation(){
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
        LocationManager.requestWhenInUseAuthorization()
        LocationManager.showsBackgroundLocationIndicator=true
        LocationManager.delegate = self
        LocationManager.startUpdatingLocation()
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let manager = manager.location?.coordinate else {return}
        let coordinate = CLLocationCoordinate2D(latitude: manager.latitude, longitude: manager.longitude)
        userloaction = coordinate
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        map.setRegion(region, animated: true)
        geoloaction()
        annotations()
        LocationManager.stopUpdatingLocation()
    }
    private func annotations(){
        let annotion = MKPointAnnotation()
        annotion.title = "My loaction"
        annotion.coordinate = userloaction!
        map.addAnnotation(annotion)
    }
    @IBAction func callaride(_ sender : UIButton){
        guard let email = Auth.auth().currentUser?.email else {return}
        if CancleRide{
            CancleRide = false
            sender.setTitle("Call a Ride", for: .normal)
            Database.database().reference().child("loaction").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (sanpshot) in
                sanpshot.ref.removeValue()
                Database.database().reference().child("loaction").removeAllObservers()
            }
        }
        else{
            let Values : [String:Any] = ["email":email,"lati":userloaction?.latitude ?? "","long":userloaction?.longitude ?? ""]
            let ref = Database.database().reference().child("loaction").childByAutoId()
            ref.setValue(Values)
            CancleRide = true
            sender.setTitle("Cancel a Ride", for: .normal)
        }
       
    }
    
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }catch{
            print("Errror")
        }
    }
    func geoloaction(){
        let geo = CLGeocoder()
        let CLLoaction = CLLocation(latitude: (userloaction?.latitude)!, longitude: (userloaction?.longitude)!)
        geo.reverseGeocodeLocation(CLLoaction) { (placemark, error) in
            if error != nil{
                
            }else{
                let place = placemark![0]
                DispatchQueue.main.async {
                    //self.labelshow.text = place.country
                }
            }
            
        }
    }
    deinit {
        
    }
    
    
}
