//
//  DatosPropierTableViewController.swift
//  consecionariaAutos
//
//  Created by Benjamin on 6/1/17.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class EditarPropietarioTableViewController: UITableViewController,MKMapViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    public static var editarlongitud:Double = 0.0
    public static var editarlatitud:Double = 0.0
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var edtFoto: UIImageView!
    @IBOutlet var edtCurp: UITextField!
    @IBOutlet var edtNombre: UITextField!
    @IBOutlet var edtAppat: UITextField!
    @IBOutlet var edtApmat: UITextField!
    @IBOutlet var edtSexo: UISegmentedControl!
    @IBOutlet var edtTelefono: UITextField!
    @IBOutlet var edtMail: UITextField!
    @IBOutlet var edtLatitud: UITextField!
    @IBOutlet var edtLongitud: UITextField!
    @IBOutlet var edtDescri: UITextField!
    
    var tipoSexo:String = "Masculino"
    var locationManager =  CLLocationManager()
    var propier:Duenio? = nil
    
    var bandera = 0
    
    @IBAction func edtTipoSexo(_ sender: UISegmentedControl) {
        switch edtSexo.selectedSegmentIndex {
        case 0:
            tipoSexo = "Masculino"
        case 1:
            tipoSexo = "Femenino"
        default:
            tipoSexo = "Masculino"
        }
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditarPropietarioTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        print("Primero Viewload")
        
        edtFoto.image = UIImage(data: propier?.foto as! Data)
        edtCurp.text = propier?.curp
        edtNombre.text = propier?.nombre
        edtAppat.text = propier?.apePat
        edtApmat.text = propier?.apeMat
        
        if(propier?.sexo == "Masculino"){
            edtSexo.selectedSegmentIndex = 0
        }else{
            edtSexo.selectedSegmentIndex = 1
        }
        edtTelefono.text = propier?.telefono
        edtMail.text = propier?.correo
        edtLatitud.text = propier?.latitud
        edtLongitud.text = propier?.longitud
        
        EditarPropietarioTableViewController.editarlongitud = Double((propier?.longitud)!)!
        EditarPropietarioTableViewController.editarlatitud = Double((propier?.latitud)!)!
        
        edtDescri.text = propier?.descripcion
        
        /*self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()*/

        actualizarUbicacion() //Caarga la ubicacion en el mini mapa

        
        setSaveBarButton() //Funcion para crear el boton de Guardar en la parte superior derecha
        
    }
    
    func actualizarUbicacion(){
        
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1,longitudeDelta: 0.1)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(Double((edtLatitud.text)!)!, Double((edtLongitud.text)!)!)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = edtDescri.text
        annotation.subtitle = edtNombre.text
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(annotation)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("Primero Will Appear")
        if bandera != 0{
            edtLongitud.text = String(EditarPropietarioTableViewController.editarlongitud)
            edtLatitud.text = String(EditarPropietarioTableViewController.editarlatitud)
        }
        actualizarUbicacion()
        
        bandera = bandera+1
    }
    
    func setSaveBarButton(){
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self , action: #selector(EditarPropietarioTableViewController.savePropier))
        navigationItem.rightBarButtonItem = saveBarButton //Creamos el botn de Guardar
    }
    
    func savePropier(){
        
        //Verifcamos que ningun campo este vacio
        if (edtCurp.text?.isEmpty)! || (edtNombre.text?.isEmpty)! || (edtAppat.text?.isEmpty)! || (edtApmat.text?.isEmpty)! || (edtDescri.text?.isEmpty)! || (edtTelefono.text?.isEmpty)! || tipoSexo.isEmpty || (edtMail.text?.isEmpty)! || edtFoto.image == nil{
            
            let alertController = UIAlertController(title: "Advertencia", message: "Verifica los datos, Algunos estan vacios", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }
        else{
            //print("Guardando")
            
            if (edtLatitud.text?.isEmpty)! || (edtLongitud.text?.isEmpty)!{
                /*let alertController = UIAlertController(title: "Informacion", message: "No se eligio ninguna direccion, se asignara una por defecto", preferredStyle: .alert)
                 alertController.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
                 self.present(alertController, animated: true, completion: nil)*/
                
                edtLatitud.text = "16.7569494180683" //Creo que es la del TEC
                edtLongitud.text = "-93.1722394986428"
            }
            
            
            if edtCurp.text != propier?.curp { //Se hace la consulta para ver si no existe la CURP
                let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Duenio")
                fetchrequest.predicate = NSPredicate(format: "curp == %@",edtCurp.text!)
                
                do{
                    let result = try managedObjectContext.fetch(fetchrequest)
                    
                    if result.count > 0 { //Si existe esa CURP
                        let alertController = UIAlertController(title: "Advertencia", message: "La curp que intenta registrar, ya se encuentra en la BD", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    }else{
                        //Imprimimos los datos
                        //print("Propietario Guardado: \(txfCurp.text!), \(txfNombre.text!), \(txfApPater.text!), \(txfApeMat.text!), \(txfCalle.text!), \(txfColonia.text!), \(txfCiudad.text!), \(txfCPostal.text!), \(txfTelefono.text!), \(tipoSexo), \(txfEmail.text!)")
                        
                        //Aqui insertamos en la Base de Datos
                        propier?.curp = edtCurp.text!
                        propier?.nombre = edtNombre.text!
                        propier?.apePat = edtAppat.text!
                        propier?.apeMat = edtApmat.text!
                        propier?.latitud = edtLatitud.text!
                        propier?.longitud = edtLongitud.text!
                        propier?.descripcion = edtDescri.text!
                        //propier.idPropier = txfCPostal.text!
                        propier?.telefono = edtTelefono.text!
                        propier?.correo = edtMail.text!
                        propier?.sexo = tipoSexo
                        
                        if let data = UIImageJPEGRepresentation(self.edtFoto.image!, 1.0){
                            propier?.foto = data as NSData
                        }
                        
                        print("Persona Actualizado")
                        print(propier as Any)
                        
                        self.navigationController!.popToRootViewController(animated: true)
                        
                    }
                    
                }catch let error as NSError{
                    print("Error al realizar la consulta \(error)")
                }
                
            }else{//Si no cambio la CURP (id), se hara un update a el mismo, no es necesario hacer la consulta para ver si ya existe
                
                //Aqui insertamos en la Base de Datos
                propier?.curp = edtCurp.text!
                propier?.nombre = edtNombre.text!
                propier?.apePat = edtAppat.text!
                propier?.apeMat = edtApmat.text!
                propier?.latitud = edtLatitud.text!
                propier?.longitud = edtLongitud.text!
                propier?.descripcion = edtDescri.text!
                //propier.idPropier = txfCPostal.text!
                propier?.telefono = edtTelefono.text!
                propier?.correo = edtMail.text!
                propier?.sexo = tipoSexo
                
                if let data = UIImageJPEGRepresentation(self.edtFoto.image!, 1.0){
                    propier?.foto = data as NSData
                }
                guardarDatosCoreData(){ //Funcion para insertar y luego regresar al lista
                    print(self.propier!)
                    self.navigationController!.popToRootViewController(animated: true)
                }
                
            }
            
        }
        
    }
    
    func guardarDatosCoreData(completion: @escaping ()->Void){ //Funcion que guarda los datos
        
        managedObjectContext.perform{
            do{
                try self.managedObjectContext.save()
                completion()
                print("Propietario Actualzado ")
            } catch  {
                print("No se pudo guardar los registros: \(error.localizedDescription)")
            }
            
            
        }
        
    }
    
    
    
    @IBAction func obtenerFotoPropiet(_ sender: UITapGestureRecognizer) { //Funcion que Al dar sobre la imagen se crea el menu para elegir la foto
        
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Tomar Foto", message: "Elegir de", preferredStyle: .actionSheet)
        
        let elegirCamara = UIAlertAction(title: "Camara", style: .default){ (action) in pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
        let albumPhotos = UIAlertAction(title: "Album de Photos", style: .default){ (action) in pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
        let fotosGuardadas = UIAlertAction(title: "Photos Guardadas", style: .default){ (action) in pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
        }
        
        let accionCancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        alertController.addAction(elegirCamara)
        alertController.addAction(albumPhotos)
        alertController.addAction(fotosGuardadas)
        alertController.addAction(accionCancelar)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.edtFoto.image = image //Obtenemos la imagen y se la ponemos al ImageView
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {//En caso de cancelar, no coloca nada en el imageview
        picker.dismiss(animated: true, completion: nil)
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //Preparando datos a mandar
        
        let viewController:EditMapaDireViewController = segue.destination as! EditMapaDireViewController
        
        //guard let viewController =  segue.source as? EditarPropietarioTableViewController else {return}

        viewController.datosSegui = ["description": (edtDescri.text!), "subtitulo": (edtNombre.text!)]
        EditarPropietarioTableViewController.editarlongitud = Double((edtLongitud.text)!)!
        EditarPropietarioTableViewController.editarlatitud = Double((edtLatitud.text)!)!
        
        print(viewController.datosSegui)
        
    }
    

    
    
    
    @IBAction func regresarEditPropier(segue: UIStoryboardSegue){
        //Solo sirve para regresar de buscar direccion a seguir editando
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
