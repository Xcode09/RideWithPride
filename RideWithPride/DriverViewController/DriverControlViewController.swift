
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
    @IBOutlet weak var mapcc:UIView!
    
    @IBOutlet weak var text: UITextView!
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
        text.isHidden = true
        text.layer.cornerRadius = 10
        text.layer.masksToBounds = true
        self.view.isUserInteractionEnabled = true
        MapConstraints()
        setLoation()
        ridersRequests()
    }
    override func viewWillAppear(_ animated: Bool) {
        Searchbarimplementation()
        Directionbtn.layer.cornerRadius = 20
        Directionbtn.layer.masksToBounds = true
        guard  let vc = Auth.auth().currentUser?.uid else {return}
        let current = Auth.auth().currentUser
        self.UID = vc
        if current != nil{
            
        }else{
            dismiss(animated: true, completion: nil)
        }
        ridersRequests()
        MapConstraints()
        ExtraThings.ShowDriverDetail(snapshotUID: UID, ChildNode: "DriverUser") { [weak self](name) in
            DispatchQueue.main.async {
                 self?.title = name
                
            }
        }
        
        
    }
    
    private func MapConstraints(){
        map.delegate = self
        map.isUserInteractionEnabled=true
        map.settings.scrollGestures=true
        map.settings.indoorPicker=true
        map.settings.myLocationButton = true
        map.settings.compassButton=true
        self.mapcc.insertSubview(map, at: 0)
        mapcc.layer.cornerRadius = 25
        mapcc.layer.masksToBounds = true
        map.leftAnchor.constraint(equalTo: mapcc.leftAnchor).isActive=true
        map.rightAnchor.constraint(equalTo: mapcc.rightAnchor).isActive=true
        map.topAnchor.constraint(equalTo: mapcc.topAnchor).isActive=true
        map.bottomAnchor.constraint(equalTo: mapcc.bottomAnchor).isActive=true
    }
    var isdri = true
    @IBAction func Directions(_ sender:UIButton){
        text.isHidden = false
        if isdri{
            ExtraThings.DrawRoutBetween(driverlocation: Driverlocation, userloaction: userlocation.coordinate, textviews: text, map: map)
            Directionbtn.setTitle("Ride Completed", for: .normal)
            isdri = false
            
        }else{
            Database.database().reference().child("loaction").queryOrdered(byChild: "email").queryEqual(toValue: emailofrider).observe(.childAdded) { (data) in
                data.ref.removeValue()
                Database.database().reference().child("loaction").removeAllObservers()
            }
            Directionbtn.setTitle("Driections", for: .normal)
            isdri = true
            Directionbtn.isHidden = true
            self.ShowRides.isHidden = false
            text.text = ""
            text.isHidden = true
        }
        
    }
    @IBAction func Settings(_ sender:UIBarButtonItem){
        performSegue(withIdentifier: "sho", sender: UID)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sho"{
            let vc = segue.destination as! DriverLogoutTableViewController
            vc.snapshotUID = sender as! String
        }
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
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
       
    }
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(Driverlocation) { response, error in
            guard let address = response?.firstResult() else {return}
            
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

        Riders.AllRides(compilation: { [weak self](rounded,location) in
            GMSGeocoder().reverseGeocodeCoordinate(location.coordinate, completionHandler: { [weak self](respone, error) in
                if error != nil {}
                else{
                    guard let address = respone?.firstResult() else {return}
                    if let adres = address.locality{
                        self?.addressofRider = adres
                    }
                    self?.userlocation = location
                }
            })
        }, DriverLocation: Driverlocation)

    }
    lazy var emailofrider = String()
    func AcceptRide(_ name: String, _ phone: String, _ email: String, _ dremail: String, vN0: String, vColor: String?) {
        emailofrider = email
        self.UpdateRide(email: dremail, location: self.userlocation,phone: phone,vN0,vColor!)
        self.Directionbtn.isHidden = false
        self.ShowRides.isHidden = true
    }
    func UpdateRide(email:String,location:CLLocation,phone:String,_ vNo:String,_ vColor:String){
        Database.database().reference().child("loaction").queryOrdered(byChild: "email").queryEqual(toValue: emailofrider).observe(.childAdded, with: { [weak self](DataSnapshot) in
            DataSnapshot.ref.updateChildValues(["Drilati" : self?.Driverlocation.latitude ?? "No value","log":self?.Driverlocation.longitude ?? "Not logi","emailofdriver":email,"phoneno":phone,"vNo":vNo,"vColor":vColor])
            Database.database().reference().child("loaction").removeAllObservers()
        })
        self.userlocation = location
    }
        @IBAction func ShowRides(_ sender:UIButton){
        if addressofRider == cityofDriver{
            let vc = UIStoryboard(name: "DriverControlPanel", bundle: nil).instantiateViewController(withIdentifier: "riders")as! CustompopViewController
            vc.delegate=self
            self.present(vc, animated: true, completion: nil)
        }else{
            let alert = ExtraThings.ErrorAlertShow(Title: "No Rides", Message: "There is not Ride Request")
            present(alert, animated: true, completion: nil)
        }
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
extension DriverControlViewController:UISearchBarDelegate,GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        viewController.dismiss(animated: true) {
            let camera = GMSCameraPosition.camera(withTarget: (place.coordinate), zoom: 18)
            self.map.camera = camera
            let marker = GMSMarker(position: place.coordinate)
            marker.title = "\(place.name)"
            marker.map = self.map
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func Searchbarimplementation(){
        let searchController = UISearchController(searchResultsController:nil)
        searchController.searchBar.placeholder = "Search Place"
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let auto = GMSAutocompleteViewController()
        auto.delegate = self
        self.present(auto, animated: true, completion: nil)
    }
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        LocationManager.startUpdatingLocation()
        return true
    }
}
