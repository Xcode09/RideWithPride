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
    
    

    @IBOutlet weak var callRideView:UIView!
    @IBOutlet weak var onewaybtn : UIButton!
    @IBOutlet weak var twowaybtn : UIButton!
    @IBOutlet weak var closepop : UIButton!
    @IBOutlet weak var textviews: UITextView!
    @IBOutlet weak var myclosebt:UIButton!
    @IBOutlet weak var btn : UIButton!
    @IBOutlet weak var CancelRide : UIButton!
    @IBOutlet weak var mapviews: UIView!
    @IBOutlet weak var MakeCall:UIBarButtonItem!
    lazy var uid = String()
    @IBOutlet weak var priceshow : UITextView!
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
        UserDefaults.standard.set(true, forKey: "issignin")
        MakeCall.isEnabled = false
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
        GETREQUEST()
        
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
    lazy var phone = String()
    lazy var starttrip = false
    func GETREQUEST(){
        Database.database().reference().child("loaction").observe(.childAdded) { (snapshot) in
            if let snas = snapshot.value as? [String:Any]{
                if let lati = snas["Drilati"] as? Double {
                    if let log = snas["log"] as? Double{
                        self.CancelRide.isHidden = true
                        guard let phoneno = snas["phoneno"] as? String else{return}
                        guard let vno = snas["vNo"] as? String else{return}
                        self.phone = phoneno
                        let driverlocation = CLLocation(latitude: lati, longitude: log)
                        let alert = ExtraThings.ErrorAlertShow(Title: "Accept your Ride", Message: "Accept Your Request by Captain and Car No  is \(vno)")
                        alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { (action) in
                            self.view.addSubview(self.textviews)
                            self.textviews.frame = self.btn.frame
                            self.textviews.frame.origin.x=self.btn.frame.origin.x
                            self.textviews.frame.origin.y=self.btn.frame.origin.y
                            let user = CLLocation(latitude: self.userloaction?.latitude ?? 0, longitude: self.userloaction?.longitude ?? 0)
                            let distance =  driverlocation.distance(from: user)/1000
                           
                            let rounded = round(distance * 100) / 100
                            OperationQueue.main.addOperation {
                                self.textviews.isHidden = false
                                self.textviews.text = "Your captain is \(rounded) KM Away and car no \(vno) "
                                self.LocationManager.startUpdatingLocation()
                                print(self.userloaction!)
                            }
                          
                            snapshot.ref.removeValue()
                            Database.database().reference().child("loaction").removeAllObservers()
                        }))
                        self.present(alert, animated: true, completion: nil)
                        self.completebut()
                        
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
    lazy var userstarttriploc = CLLocationCoordinate2D()
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
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading){
        let location = manager.location
        let rc = CLLocation(latitude: (self.userloaction?.latitude)!, longitude: self.userloaction!.longitude)
        let distance = location?.distance(from: rc)
        let rounded = round(distance ?? 0 * 100) / 100
        let aa = Double(1)/Double(12)
        let sss = Double(aa*rounded)
        let price = sss * 95
        let ddd = price + 120
        self.view.insertSubview(priceshow, aboveSubview: mapviews)
        self.priceshow.frame = self.mapviews.frame
        self.priceshow.center = self.mapviews.center
       
        priceshow.text = "Your distance is \(Int(rounded)) \(Int(ddd))"
        LocationManager.stopUpdatingHeading()
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
       
        callRideView.layer.cornerRadius  = 34
        callRideView.layer.borderWidth = 2
        callRideView.layer.borderColor = UIColor.blue.cgColor
        callRideView.layer.masksToBounds = true
        onewaybtn.layer.cornerRadius = 20
        onewaybtn.layer.masksToBounds = true
        twowaybtn.layer.cornerRadius = 20
        twowaybtn.layer.masksToBounds = true
        closepop.layer.cornerRadius = 10
        closepop.layer.masksToBounds = true
        self.view.insertSubview(callRideView, aboveSubview: mapviews)
        self.callRideView.frame = self.mapviews.frame
        self.callRideView.center = self.mapviews.center
        callRideView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5) {
            self.callRideView.transform = .identity
            self.btn.isHidden = true
        }
        
        
        

    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        GETREQUEST()
    }
    
    @IBAction func CancelRide(_ sender:UIButton){
        let alert = ExtraThings.ErrorAlertShow(Title: "Cancel Ride", Message: "Are you sure to Cancel a Ride?")
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
            guard let email = Auth.auth().currentUser?.email else {return}
            Database.database().reference().child("loaction").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (sanpshot) in
                sanpshot.ref.removeValue()
                Database.database().reference().child("loaction").removeAllObservers()
                
            }
            self.btn.isHidden=false
            self.CancelRide.isHidden=true
            self.isSelect=false
            UserDefaults.standard.set(self.isSelect, forKey: "tr")
        }))
        self.present(alert, animated: true, completion: nil)
        
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
