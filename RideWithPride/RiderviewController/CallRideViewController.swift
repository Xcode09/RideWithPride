//
//  CallRideViewController.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 09/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseAuth
import FirebaseDatabase
class CallRideViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {
    @IBOutlet weak var stack : UIStackView!
    @IBOutlet weak var btn : UIButton!
    @IBOutlet weak var CancelRide : UIButton!
    
    @IBOutlet weak var la: UILabel!
    /// Mark: properties
    var userloaction : CLLocationCoordinate2D?
    lazy var LocationManager = CLLocationManager()
    var snap : [DataSnapshot] = []
    var DriverName:String?
    var corrdination:CLLocationCoordinate2D?
    lazy var lat:CLLocationDegrees = CLLocationDegrees()
    lazy var log:CLLocationDegrees = CLLocationDegrees()
    lazy var Driverlocation = CLLocationCoordinate2D()
    var custompop:CustompopViewController?
    var isSelect : Bool?
    lazy var map:GMSMapView={
        var map = GMSMapView()
        map.isBuildingsEnabled = true
        map.isMyLocationEnabled = true
        map.settings.compassButton = true
        map.settings.myLocationButton=true
        map.delegate = self
        map.translatesAutoresizingMaskIntoConstraints=false
        return map
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.insertSubview(map, at: 0)
        btn.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        btn.layer.cornerRadius = 10
        btn.setTitleColor(UIColor.white, for: .normal)
        CancelRide.layer.cornerRadius = 10
        CancelRide.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        CancelRide.setTitleColor(UIColor.white, for: .normal)
        extractedFuncofconstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let issle =  UserDefaults.standard.bool(forKey: "tr")
        print(issle)
        if issle == true{
            
                self.btn.isHidden = true
                self.CancelRide.isHidden=false
            UIView.animate(withDuration: 0.5) {
                self.viewDidLayoutSubviews()
            }
        }else{
            self.CancelRide.isHidden=true
            self.btn.isHidden=false
            UIView.animate(withDuration: 0.5) {
                self.viewDidLayoutSubviews()
            }
            
        }
        setLoation()
        Database.database().reference().child("loaction").observe(.childAdded) { (snapshot) in
            if let snas = snapshot.value as? [String:Any]{
                guard let lati = snas["Drilati"] as? Double else{return}
                guard let log = snas["log"] as? Double else{return}
                let driverlocation = CLLocationCoordinate2D(latitude: lati, longitude: log)
                let round = Riders.calculateDistance(DriverLocation: driverlocation, RiderLocation: self.userloaction!)
                print(round)
                
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "cancel"), object: nil, queue: OperationQueue.main) { (noti) in
            let alert = ExtraThings.ErrorAlertShow(Title: "Cancel", Message: "Driver Cancel Your Request")
            self.present(alert, animated: true, completion: nil)
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Acc"), object: nil, queue: OperationQueue.main) { (noti) in
            guard let info = noti.userInfo!["email"] as? String else{return}
            let alert = ExtraThings.ErrorAlertShow(Title: "Driver Accept a Ride", Message: info)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func setLoation(){
        LocationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        LocationManager.requestWhenInUseAuthorization()
        LocationManager.showsBackgroundLocationIndicator=true
        LocationManager.delegate = self
        LocationManager.activityType = .automotiveNavigation
        LocationManager.pausesLocationUpdatesAutomatically = false
        LocationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locatio = locations.last else {return}
        let manager = locatio.coordinate
        let coordinate = CLLocationCoordinate2D(latitude: manager.latitude, longitude: manager.longitude)
        userloaction = coordinate
        let region = GMSCameraPosition.camera(withTarget: locatio.coordinate, zoom: 25)
        map.camera = region
        annotations()
        LocationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        LocationManager.stopUpdatingLocation()
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        LocationManager.startUpdatingLocation()
    }
    
    private func annotations(){
        GMSPlacesClient().currentPlace { (placelikehood, error) in
            if error != nil{
                print("Error")
            }else{
                guard let place = placelikehood else {return}
                for places in place.likelihoods{
                    DispatchQueue.main.async {
                        let usrannotion = GMSMarker(position: self.userloaction!)
                        usrannotion.title = places.place.name
                        usrannotion.snippet = places.place.formattedAddress
                        usrannotion.map = self.map
                    }
                }
            }
        }
    }
    
    
    @IBAction func callaride(_ sender : UIButton){
        guard let email = Auth.auth().currentUser?.email else {
            print("Email is not found")
            return}
            let Values : [String:Any] = ["email":email,"lati":userloaction?.latitude ?? "","long":userloaction?.longitude ?? ""]
            let ref = Database.database().reference().child("loaction").childByAutoId()
            ref.setValue(Values)
        UIView.animate(withDuration: 0.5) {
            self.btn.isHidden=true
            self.CancelRide.isHidden=false
            self.viewDidLayoutSubviews()
        }
        
        isSelect = true
        UserDefaults.standard.set(isSelect, forKey: "tr")
        }
    @IBAction func CancelRide(_ sender:UIButton){
        guard let email = Auth.auth().currentUser?.email else {return}
        Database.database().reference().child("loaction").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (sanpshot) in
            sanpshot.ref.removeValue()
            Database.database().reference().child("loaction").removeAllObservers()
        }
        UIView.animate(withDuration: 0.5) {
            self.btn.isHidden=false
            self.CancelRide.isHidden=true
            self.viewDidLayoutSubviews()
        }
        
        isSelect=false
        UserDefaults.standard.set(isSelect, forKey: "tr")
}
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension CLLocationCoordinate2D:Equatable{
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool{
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
