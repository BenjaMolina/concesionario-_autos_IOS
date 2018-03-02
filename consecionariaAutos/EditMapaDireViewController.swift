//
//  EditMapaDireViewController.swift
//  consecionariaAutos
//
//  Created by Benjamin on 6/2/17.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class EditMapaDireViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var imHere:MKPointAnnotation = MKPointAnnotation()
    
    var datosSegui = [String:String]()
    var touchCoordinate = CLLocationCoordinate2D()
    
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
        
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005,longitudeDelta: 0.005)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(EditarPropietarioTableViewController.editarlatitud, EditarPropietarioTableViewController.editarlongitud)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
        //let annotation = MKPointAnnotation()
        imHere.coordinate = location
        imHere.title = datosSegui["description"]
        imHere.subtitle = datosSegui["subtitulo"]
        mapView.addAnnotation(imHere)

         setDoneBarButton() //Funcion para crear el boton de Guardar en la parte superior derecha
    }
    
    func setDoneBarButton(){
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self , action: #selector(EditMapaDireViewController.doneEditDirec))
        navigationItem.rightBarButtonItem = saveBarButton //Creamos el botn de Guardar
    }
    
    func doneEditDirec(){
        if(!touchCoordinate.latitude.isEqual(to: 0.0)){
            EditarPropietarioTableViewController.editarlongitud = Double(touchCoordinate.longitude)
            EditarPropietarioTableViewController.editarlatitud = Double(touchCoordinate.latitude)
            
            print("Se escogio una direccion")
        }
        
        performSegue(withIdentifier: "backEditPropier", sender: self) //Regresamos al view anterior
        //self.navigationController!.popToRootViewController(animated: true)
    }

    @IBAction func agregarNuevaDire(_ sender: UILongPressGestureRecognizer) {
        
        //Funcion para agregar el indicador en el mapa para la nueva direccion
        
        if sender.state == UIGestureRecognizerState.ended {
            
            let touchPoint = sender.location(in: mapView)
            touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinate
            annotation.title = "Nueva direccion"
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(annotation) //drops the pin
            
            print(touchCoordinate.latitude)
            print(touchCoordinate.longitude)
            
            
        }

    }
    
   /* @IBAction func nuevaDire(_ sender: UITapGestureRecognizer) {
        //Funcion para agregar el indicador en el mapa para la nueva direccion
        
        if sender.state == UIGestureRecognizerState.ended {
            
            let touchPoint = sender.location(in: mapView)
            touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinate
            annotation.title = "Nueva direccion"
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(annotation) //drops the pin
            
            print(touchCoordinate.latitude)
            print(touchCoordinate.longitude)
            
            
        }

    }*/

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: \(error.localizedDescription)")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
