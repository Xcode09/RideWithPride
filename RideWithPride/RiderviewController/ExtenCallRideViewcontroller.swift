//
//  ExtenCallRideViewcontroller.swift
//  RideWithPride
//
//  Created by Muhammad Ali on 20/07/2018.
//  Copyright © 2018 Muhammad Ali. All rights reserved.
//

import Foundation
import CoreLocation
import GooglePlaces
import GoogleMaps
import FirebaseAuth
import FirebaseDatabase
extension CallRideViewController:UISearchBarDelegate,GMSAutocompleteViewControllerDelegate{
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.lat1 = place.coordinate.latitude
        self.long2 = place.coordinate.longitude
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
        dismiss(animated: true, completion: nil)
    }
    
    
    func Searchbarimplementation(){
        let searchController = UISearchController(searchResultsController:nil)
        searchController.searchBar.placeholder = "Search Place"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
      
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let auto = GMSAutocompleteViewController()
        auto.delegate = self
        present(auto, animated: true, completion: nil)
    }
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        LocationManager.startUpdatingLocation()
        return true
    }
   
     func extractedFuncofconstraints() {
        mapviews.insertSubview(map, at: 0)
        mapviews.layer.cornerRadius = 24
        mapviews.layer.masksToBounds = true
        CancelRide.layer.cornerRadius = 20
        map.leftAnchor.constraint(equalTo: mapviews.leftAnchor).isActive=true
        map.rightAnchor.constraint(equalTo:  mapviews.rightAnchor).isActive=true
        map.topAnchor.constraint(equalTo:  mapviews.topAnchor).isActive=true
        map.bottomAnchor.constraint(equalTo:  mapviews.bottomAnchor).isActive=true
    }
    @IBAction func onyway(_ sender:UIButton){
                if let email = Auth.auth().currentUser?.email  {
                    let Values : [String:Any] = ["email":email,"lati":userloaction?.latitude ?? "","long":userloaction?.longitude ?? "","way":"oneway"]
                     Database.database().reference().child("loaction").childByAutoId().setValue(Values)
                    self.btn.isHidden=true
                    self.CancelRide.isHidden=false
                isSelect = true
                UserDefaults.standard.set(isSelect, forKey: "tr")
                }else{
                    print("Email is not")
                }
        UIView.animate(withDuration: 0.5, animations: {
            self.callRideView.alpha = 0
        }) { (tru) in
            self.callRideView.removeFromSuperview()
            self.callRideView.alpha = 1
        }
        
    }
    @IBAction func twoway(_ sender:UIButton){
        if let email = Auth.auth().currentUser?.email  {
            let Values : [String:Any] = ["email":email,"lati":userloaction?.latitude ?? "","long":userloaction?.longitude ?? "","way":"Twoway"]
            Database.database().reference().child("loaction").childByAutoId().setValue(Values)
            self.btn.isHidden=true
            self.CancelRide.isHidden=false
            isSelect = true
            UserDefaults.standard.set(isSelect, forKey: "tr")
        }else{
            print("Email is not")
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.callRideView.alpha = 0
        }) { (tru) in
            self.callRideView.removeFromSuperview()
            self.callRideView.alpha = 1
           
        }
    }
    @IBAction func closepop(_ sender:UIButton){
        UIView.animate(withDuration: 0.5, animations: {
            self.callRideView.alpha = 0
        }) { (tru) in
            self.callRideView.removeFromSuperview()
            self.callRideView.alpha = 1
            self.btn.isHidden = false
        }
        
    }
    
    func completebut(){
        self.view.addSubview(myclosebt)
        myclosebt.frame.origin.x = CancelRide.frame.origin.x
        myclosebt.frame.origin.y = CancelRide.frame.origin.y
        MakeCall.isEnabled = true
    }
    @IBAction func completeRide(_ sender:UIButton){
        LocationManager.startUpdatingHeading()
        map.clear()
        textviews.removeFromSuperview()
        btn.isHidden = false
        MakeCall.isEnabled = false
        myclosebt.removeFromSuperview()
    }
    @IBAction func MakeaPhoneCall(_ sender:UIBarButtonItem){
        guard let phoneno = URL(string: "tel://\(phone)") else {return}
        UIApplication.shared.open(phoneno, options: [:])
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.priceshow.removeFromSuperview()
    }
}

