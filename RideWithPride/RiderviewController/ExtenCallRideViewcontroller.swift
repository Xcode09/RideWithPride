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
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchBar.text else{return}
//        CLGeocoder().geocodeAddressString(text) { (PLACE, eRROR) in
//            if eRROR != nil{
//                print(eRROR?.localizedDescription)
//            }else{
//                guard let last = PLACE?.last else {return}
//                let camera = GMSCameraPosition.camera(withTarget: (last.location?.coordinate)!, zoom: 10)
//                self.map.camera = camera
//                let marker = GMSMarker(position: (last.location?.coordinate)!)
//                marker.title = "\(last.name!)"
//                marker.map = self.map
//            }
//
//        }
//
//    }
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
    
}

