
//  DriverControlViewController.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 14/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth
class DriverControlViewController: UIViewController,CLLocationManagerDelegate {
    var Driverlocation = CLLocationCoordinate2D()
    var LocationManager = CLLocationManager()
    lazy var map:MKMapView={
        var map = MKMapView()
        map.showsCompass = true
        map.isScrollEnabled = true
        map.showsBuildings = true
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints=false
        return map
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        MapConstraints()
        setLoation()
        ridersRequests()
    }
    private func MapConstraints(){
        self.view.insertSubview(map, at: 0)
        map.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        map.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        map.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        map.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
    }
    @IBAction func AcceptRide(_ sender:UIButton){
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locatio = locations.last else {return}
        let manager = locatio.coordinate
        let coordinate = CLLocationCoordinate2D(latitude: manager.latitude, longitude: manager.longitude)
        Driverlocation = coordinate
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        map.setRegion(region, animated: true)
        annotations()
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
    private func annotations(){
        let usrannotion = MKPointAnnotation()
        usrannotion.title = "My cuurent loaction"
        usrannotion.coordinate = Driverlocation
        map.addAnnotations([usrannotion])
    }
    private func ridersRequests(){
        Riders.AllRides(compilation: { (rounded,email,location) in
            let driverclplacemark = MKPlacemark(coordinate: self.Driverlocation)
            let riderclplace = MKPlacemark(coordinate: location.coordinate)
            if driverclplacemark.locality == riderclplace.locality {
                let alert = ExtraThings.ErrorAlertShow(Title: email, Message: "I want to a Ride ")
                alert.addAction(UIAlertAction(title: "Accept the Ride", style: UIAlertActionStyle.default, handler: { (alert) in
                    self.UpdateRide(email: email, location: location)
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                print("location is different")
            }
            
        }, DriverLocation: Driverlocation)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        LocationManager.stopUpdatingLocation()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        LocationManager.startUpdatingLocation()
    }
    
    private func UpdateRide(email:String,location:CLLocation){
    Database.database().reference().child("loaction").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded, with: { (DataSnapshot) in
    DataSnapshot.ref.updateChildValues(["Drilati" : self.Driverlocation.latitude,"log":self.Driverlocation.longitude])
    Database.database().reference().child("loaction").removeAllObservers()
    })
    CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemark, error) in
    guard let place = placemark?.first else {return}
    let MKPlace = MKPlacemark(placemark: place)
    let item = MKMapItem(placemark: MKPlace)
    item.name = email
    let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
    item.openInMaps(launchOptions: options)
    })
    }
}
