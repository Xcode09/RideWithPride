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

class CallRideViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate{
    
    
    @IBOutlet weak var stack : UIStackView!
    
    @IBOutlet weak var textviews: UITextView!
    @IBOutlet weak var btn : UIButton!
    @IBOutlet weak var CancelRide : UIButton!
    @IBOutlet weak var la: UILabel!
    @IBOutlet weak var mapviews: UIView!
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
    lazy var lat1 = CLLocationDegrees()
    lazy var long2 = CLLocationDegrees()
    var isSelect : Bool?
    lazy var map:GMSMapView={
        var map = GMSMapView()
        map.isBuildingsEnabled = true
        map.isMyLocationEnabled = true
        map.settings.compassButton = true
        map.settings.myLocationButton = true
        map.delegate = self
        map.translatesAutoresizingMaskIntoConstraints=false
        return map
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        Searchbarimplementation()
        btn.backgroundColor = UIColor(cgColor: CGColor.ColorCombination())
        btn.layer.cornerRadius = 25
        btn.layer.masksToBounds=true
        btn.setTitleColor(UIColor.white, for: .normal)
        CancelRide.layer.cornerRadius = 10
        CancelRide.backgroundColor = UIColor(cgColor: CGColor.ColorCombination())
        CancelRide.setTitleColor(UIColor.white, for: .normal)
        //CheckButtons()
        CancelRide.isHidden = true
        textviews.isHidden = true
        textviews.layer.cornerRadius = 20
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
        setLoation()
        ExtraThings.ShowDriverDetail(snapshotUID: ui, ChildNode: "user") { [weak self](name) in
            DispatchQueue.main.async {
                self?.title = name.uppercased()
            }
        }
        
        
    }
    func CheckButtons(){
        let rr = UserDefaults.standard.bool(forKey: "tr")
        if rr == true{
            btn.isHidden = true
            CancelRide.isHidden = false
        }else{
            btn.isHidden = false
            CancelRide.isHidden = true
        }
    }
    
    func GETREQUEST(){
        Database.database().reference().child("loaction").observe(.childAdded) { (snapshot) in
            if let snas = snapshot.value as? [String:Any]{
                if let lati = snas["Drilati"] as? Double {
                    if let log = snas["log"] as? Double{
                        self.CancelRide.isHidden = true
                        let driverlocation = CLLocationCoordinate2D(latitude: lati, longitude: log)
                        let alert = ExtraThings.ErrorAlertShow(Title: "Accept", Message: "Accept Your Request")
                        alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { (action) in
                            
                            ExtraThings.DrawRoutBetween(driverlocation: driverlocation, userloaction: self.userloaction!, textviews: self.textviews, map: self.map)
                            self.btn.isHidden = true
                            snapshot.ref.removeValue()
                            Database.database().reference().child("loaction").removeAllObservers()
                        }))
                        self.present(alert, animated: true, completion: nil)

                    }else{
                        self.CancelRide.isHidden = false
                    }
                }

            }
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
        let region = GMSCameraPosition.camera(withTarget: userloaction!, zoom: 15)
        map.camera = region
        annotations()
        LocationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        GETREQUEST()
       
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
        if let email = Auth.auth().currentUser?.email  {
            let Values : [String:Any] = ["email":email,"lati":userloaction?.latitude ?? "","long":userloaction?.longitude ?? ""]
             Database.database().reference().child("loaction").childByAutoId().setValue(Values)
            self.btn.isHidden=true
            self.CancelRide.isHidden=false
        isSelect = true
        UserDefaults.standard.set(isSelect, forKey: "tr")
        }else{
            print("Email is not")
        }
    }
    @IBAction func CancelRide(_ sender:UIButton){
        guard let email = Auth.auth().currentUser?.email else {return}
        Database.database().reference().child("loaction").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (sanpshot) in
            sanpshot.ref.removeValue()
            Database.database().reference().child("loaction").removeAllObservers()
            
        }
        self.btn.isHidden=false
        self.CancelRide.isHidden=true
        isSelect=false
        UserDefaults.standard.set(isSelect, forKey: "tr")
}
    @IBAction func show(_ sender:UIBarButtonItem){
        performSegue(withIdentifier: "show", sender: uid)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "show"{
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
