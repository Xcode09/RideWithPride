
//  DriverControlViewController.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 14/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import FirebaseDatabase
import CoreLocation
import FirebaseAuth
class DriverControlViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate,RiderDelegate {
    @IBOutlet weak var Directionbtn:UIButton!
    @IBOutlet weak var ShowRides:UIButton!
    
    @IBOutlet weak var Navi: UINavigationBar!
    lazy var Driverlocation = CLLocationCoordinate2D()
    lazy var LocationManager = CLLocationManager()
    lazy var userlocation = CLLocation()
    lazy var cityofDriver = String()
    lazy var polyline = GMSPolyline()
    lazy var points = String()
    lazy var addressofRider = String()
    lazy var UID = String()
    lazy var map:GMSMapView={
        var map = GMSMapView(frame: .zero)
        map.isMyLocationEnabled = true
        map.translatesAutoresizingMaskIntoConstraints=false
        return map
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        Directionbtn.isHidden = true
        self.view.isUserInteractionEnabled = true
        MapConstraints()
        setLoation()
        //ridersRequests()
    }
    override func viewWillAppear(_ animated: Bool) {
        guard  let vc = Auth.auth().currentUser?.uid else {return}
        let current = Auth.auth().currentUser
        self.UID = vc
        if current != nil{
            
        }else{
            dismiss(animated: true, completion: nil)
        }
        ridersRequests()
        MapConstraints()
        ShowDriverDetail(snapshotUID: UID)
    }
    private func MapConstraints(){
        map.delegate = self
        map.isUserInteractionEnabled=true
        map.settings.scrollGestures=true
        //map.settings.myLocationButton=true
        map.settings.indoorPicker=true
        map.settings.compassButton=true
        self.view.insertSubview(map, at: 0)
        map.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        map.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        map.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        map.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
    }
    @IBAction func Directions(_ sender:UIButton){
        DrawRoute(Driverlocation: Driverlocation, location: userlocation)
    }
    @IBAction func Settings(_ sender:UIBarButtonItem){
        let vc = UIStoryboard(name: "DriverControlPanel", bundle: nil).instantiateViewController(withIdentifier: "Driverl") as!DriverLogoutTableViewController
        vc.snapshotUID = UID
        present(vc, animated: true, completion: nil)
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locatio = locations.last else {return}
        let manager = locatio.coordinate
        let coordinate = CLLocationCoordinate2D(latitude: manager.latitude, longitude: manager.longitude)
        Driverlocation = coordinate
        let region = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        map.camera = region
        self.map.clear()
        self.LocationManager.stopUpdatingLocation()
    }
    func setLoation(){
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
        LocationManager.requestWhenInUseAuthorization()
        LocationManager.showsBackgroundLocationIndicator=true
        LocationManager.delegate = self
        LocationManager.activityType = .automotiveNavigation
        LocationManager.pausesLocationUpdatesAutomatically = false
        LocationManager.startUpdatingLocation()
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
        Navi.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(cancel), name: NSNotification.Name(rawValue: "cancel"), object: nil)
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        Navi.isHidden = true
       
    }
    @objc func cancel(){
        print("error")
    }
    var selectimage=true
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(Driverlocation) { response, error in
            guard let address = response?.firstResult() else {return}
            
            // 3
            let marker = GMSMarker(position: address.coordinate)
            marker.title = address.country
            guard let city = address.locality else {return}
            guard let cityarea = address.administrativeArea else {return}
            guard let area = address.subLocality else {return}
            
            marker.snippet = "City is \(String(describing: city)) and Region is \(String(describing: cityarea)) Area is \(String(describing:area))"
            marker.icon = #imageLiteral(resourceName: "icon-1")
            self.cityofDriver = city
            marker.map = self.map
            
            // 4
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    private func ridersRequests(){

        Riders.AllRides(compilation: { (rounded,location) in
            GMSGeocoder().reverseGeocodeCoordinate(location.coordinate, completionHandler: { (respone, error) in
                if error != nil {}
                else{
                    guard let address = respone?.firstResult() else {return}
                    if let adres = address.locality{
                          self.addressofRider = adres
                    }
                    self.userlocation = location
                }
            })
        }, DriverLocation: Driverlocation)

    }
    func Cancelride() {
        print("Ridecancel")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cancel"), object: nil)
    }
    func AcceptRide(_ email: String) {
        guard let auth = Auth.auth().currentUser?.email else {return}
        UpdateRide(email: email, location: userlocation)
        Directionbtn.isHidden = false
        
    }
    func UpdateRide(email:String,location:CLLocation){
        Database.database().reference().child("loaction").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (DataSnapshot) in
            DataSnapshot.ref.updateChildValues(["Drilati" : self.Driverlocation.latitude,"log":self.Driverlocation.longitude])
            Database.database().reference().child("loaction").removeAllObservers()
        })
        self.userlocation = location
    }
    private func DrawRoute(Driverlocation:CLLocationCoordinate2D,location:CLLocation){
        print(Driverlocation)
        print(location)
                        let path = GMSMutablePath()
                        path.add(Driverlocation)
                        path.add(location.coordinate)
                        let polyline = GMSPolyline(path: path)
            polyline.map = nil
        map.clear()
                        polyline.strokeColor = .red
                        polyline.strokeWidth = 8
                        polyline.map = self.map
        }
    @IBAction func ShowRides(_ sender:UIButton){
        if addressofRider == cityofDriver{
            let vc = UIStoryboard(name: "DriverControlPanel", bundle: nil).instantiateViewController(withIdentifier: "riders")as! CustompopViewController
            vc.delegate=self
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
}
