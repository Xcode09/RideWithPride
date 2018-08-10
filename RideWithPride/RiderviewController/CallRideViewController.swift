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
class CallRideViewController: UIViewController,CLLocationManagerDelegate {
    @IBOutlet weak var Sideview : UIView!
    @IBOutlet weak var layout : NSLayoutConstraint!
    @IBOutlet weak var SideBaremail: UILabel!
    @IBOutlet weak var stack : UIStackView!
    @IBOutlet weak var btn : UIButton!
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
    lazy var map:GMSMapView={
        var map = GMSMapView()
        map.isBuildingsEnabled = true
        map.isMyLocationEnabled = true
        map.settings.compassButton = true
        map.translatesAutoresizingMaskIntoConstraints=false
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.insertSubview(map, at: 0)
        btn.backgroundColor = UIColor(cgColor: CGColor.colorForbtn())
        btn.layer.cornerRadius = 10
        btn.setTitleColor(UIColor.white, for: .normal)
        extractedFuncofconstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Database.database().reference().child("DriverUser").observe(.childAdded) { (snapshot) in
            self.snap.append(snapshot)
        }
        setLoation()
        
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
}
extension CLLocationCoordinate2D:Equatable{
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool{
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
