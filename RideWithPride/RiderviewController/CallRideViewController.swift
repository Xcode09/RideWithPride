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
    @IBOutlet weak var Sideview : UIView!
    @IBOutlet weak var layout : NSLayoutConstraint!
    @IBOutlet weak var SideBaremail: UILabel!
    @IBOutlet weak var stack : UIStackView!
    
    /// Mark: properties
    var userloaction : CLLocationCoordinate2D?
    var LocationManager = CLLocationManager()
    var CancleRide:Bool=false
    var timer : Timer?
    var snap : [DataSnapshot] = []
    var DriverName:String?
    var corrdination:CLLocationCoordinate2D?
    var lat:CLLocationDegrees = CLLocationDegrees()
    var log:CLLocationDegrees = CLLocationDegrees()
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
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints=false
        return view
    }()
    lazy var label : UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.bold)
        label.textColor = UIColor(cgColor: CGColor.colorForbtn())
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.insertSubview(map, at: 0)
        self.view.addSubview(viewshow)
        extractedFuncofconstraints()
        labelShow()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Database.database().reference().child("DriverUser").observe(.childAdded) { (snapshot) in
            self.snap.append(snapshot)
        }
        setLoation()
        
    }
    func setLoation(){
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
        LocationManager.requestWhenInUseAuthorization()
        LocationManager.showsBackgroundLocationIndicator=true
        LocationManager.delegate = self
        LocationManager.activityType = .automotiveNavigation
        LocationManager.pausesLocationUpdatesAutomatically = false
        LocationManager.startUpdatingLocation()
        //        let time = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(startlocation), userInfo: nil, repeats: true)
        //        time.fire()
        
        
        
    }
    //    @objc func startlocation(){
    //        DispatchQueue.global(qos: .background).async {
    //            self.LocationManager.startUpdatingLocation()
    //        }
    //    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locatio = locations.last else {return}
        let manager = locatio.coordinate
        let coordinate = CLLocationCoordinate2D(latitude: manager.latitude, longitude: manager.longitude)
        userloaction = coordinate
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: true)
        geoloaction()
        annotations()
        LocationManager.stopUpdatingLocation()
    }
    private func annotations(){
        let usrannotion = MKPointAnnotation()
        usrannotion.title = "My cuurent loaction"
        usrannotion.coordinate = userloaction!
        map.addAnnotations([usrannotion])
    }
    
    
    @IBAction func callaride(_ sender : UIButton){
        guard let email = Auth.auth().currentUser?.email else {
            print("Email is not found")
            return}
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
            sender.setTitle("Cancel", for: .normal)
        }
        
    }
    
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        guard let email = Auth.auth().currentUser?.email else {
            
            return}
            Database.database().reference().child("loaction").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (sanpshot) in
            sanpshot.ref.removeValue()
            Database.database().reference().child("loaction").removeAllObservers()
        }
        do{
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        }catch{
            print("Errror")
        }
    }
    
    deinit {
        
    }
    
}
extension CLLocationCoordinate2D:Equatable{
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool{
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
