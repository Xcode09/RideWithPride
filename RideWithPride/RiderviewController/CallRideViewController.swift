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
    lazy var uid = String()
    @IBOutlet weak var nav : UINavigationBar!
    /// Mark: properties
    var userloaction : CLLocationCoordinate2D?
    lazy var LocationManager = CLLocationManager()
    var snap : [DataSnapshot] = []
    var DriverName:String?
    var corrdination:CLLocationCoordinate2D?
    lazy var lat:CLLocationDegrees = CLLocationDegrees()
    lazy var log:CLLocationDegrees = CLLocationDegrees()
    lazy var Driverlocation = CLLocationCoordinate2D()
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
        let vc = Auth.auth().currentUser
        if vc != nil{
            
        }else{
            self.dismiss(animated: true, completion: nil)
        }
        guard let ui = Auth.auth().currentUser?.uid else {
            return
        }
        self.uid = ui
        
        let issle =  UserDefaults.standard.bool(forKey: "tr")
        print(issle)
        if issle == true{
            
                self.btn.isHidden = true
                self.CancelRide.isHidden=false
        }else{
            self.CancelRide.isHidden=true
            self.btn.isHidden=false
            
        }
        setLoation()
        GETREQUEST()
        
    }
    
    
    func GETREQUEST(){
        Database.database().reference().child("loaction").observe(.childAdded) { (snapshot) in
            if let snas = snapshot.value as? [String:Any]{
                if let lati = snas["Drilati"] as? Double {
                    if let log = snas["log"] as? Double{
                        let driverlocation = CLLocationCoordinate2D(latitude: lati, longitude: log)
                        let alert = ExtraThings.ErrorAlertShow(Title: "Accept", Message: "Accept Your Request")
                        alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { (action) in
                            self.drawroutebetween(driverLocation: driverlocation)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                }
                
            }
        }
    }
    func drawroutebetween(driverLocation:CLLocationCoordinate2D){
        let path = GMSMutablePath()
        path.add(userloaction!)
        path.add(driverLocation)
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = .blue
        polyline.strokeWidth = 15
        polyline.map = self.map
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
        nav.isHidden = true
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        LocationManager.startUpdatingLocation()
        nav.isHidden = false
    }
   
    
    
    private func annotations(){
        map.clear()
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cancel"), object: nil)
        
        isSelect=false
        UserDefaults.standard.set(isSelect, forKey: "tr")
}
    @IBAction func show(_ sender:UIBarButtonItem){
        performSegue(withIdentifier: "cell", sender: uid)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "cell"{
                let vc = segue.destination as! LogoutRiderViewController
                vc.snapshotUID = sender as! String
            }

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
