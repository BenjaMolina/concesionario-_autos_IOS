//
//  MapaDireccionViewController.swift
//  consecionariaAutos
//
//  Created by Benjamin on 6/1/17.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapaDireccionViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var imHere:MKPointAnnotation = MKPointAnnotation()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.mapType = MKMapType.standard
        //mapView.mapType = MKMapType.satellite
        //mapView.mapType = MKMapType.hybrid
        if #available(iOS 9.0, *) {
            //mapView.mapType = MKMapType.hybridFlyover
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 9.0, *) {
            // mapView.mapType = MKMapType.satelliteFlyover
        } else {
            // Fallback on earlier versions
        }
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        self.mapView.userTrackingMode = .follow

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        /*let location = locations.last
        let center = CLLocationCoordinate2DMake(location!.coordinate.latitude, (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.mapView.setRegion(region,animated: true)
        self.locationManager.stopUpdatingLocation()*/
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: \(error.localizedDescription)")
    }

    
    @IBAction func insert(_ sender: UITapGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            
            let touchPoint = sender.location(in: mapView)
            let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinate
            annotation.title = "Event place"
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(annotation) //drops the pin
            
            print(touchCoordinate.latitude)
            print(touchCoordinate.longitude)
            
            AgregarPropietario.direccionLongitud = Double(touchCoordinate.longitude)
            AgregarPropietario.direccionLatitud = Double(touchCoordinate.latitude)
        }
        
        //print(sender.state)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
