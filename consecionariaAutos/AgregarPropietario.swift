//
//  AgregarPropietario.swift
//  consecionariaAutos
//
//  Created by Benjamin on 5/31/17.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class AgregarPropietario: UITableViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    public static var direccionLongitud:Double = 0.0
    public static var direccionLatitud:Double = 0.0
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var fotoPropietario: UIImageView!
    @IBOutlet var txfCurp: UITextField!
    @IBOutlet var txfNombre: UITextField!
    @IBOutlet var txfApPater: UITextField!
    @IBOutlet var txfApeMat: UITextField!
    @IBOutlet var txfSexo: UISegmentedControl!
    //@IBOutlet var txfCalle: UITextField! //Latitud
    //@IBOutlet var txfColonia: UITextField! //longitud
    //@IBOutlet var txfCiudad: UITextField! // DDescripcion
    //@IBOutlet var txfCPostal: UITextField! //idPropietario
    @IBOutlet var txfLatitud: UITextField!
    @IBOutlet var txfLongitud: UITextField!
    @IBOutlet var txfDescripcion: UITextField!
    
    @IBOutlet var txfTelefono: UITextField!
    @IBOutlet var txfEmail: UITextField!
    
    var tipoSexo:String = "Masculino"
    
    @IBAction func elegirSexo(_ sender: UISegmentedControl) {
        
        switch txfSexo.selectedSegmentIndex {
        case 0:
            tipoSexo = "Masculino"
        case 1:
            tipoSexo = "Femenino"
        default:
            tipoSexo = "Masculino"
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if AgregarPropietario.direccionLongitud != 0.0 || AgregarPropietario.direccionLatitud != 0.0{
            txfLongitud.text = String(AgregarPropietario.direccionLongitud)
            txfLatitud.text = String(AgregarPropietario.direccionLatitud)
        }
        else{
            txfLatitud.text = ""
            txfLongitud .text = ""
        }
        
        //print("Nuevos Valores a las varibales \(AgregarPropietario.direccionLongitud)")
        //print("Nuevos Valores a las varibales \(AgregarPropietario.direccionLatitud)")
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AgregarPropietario.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        txfLatitud.text = ""
        txfLongitud .text = ""
        
        setSaveBarButton() //Funcion para crear el boton de Guardar en la parte superior derecha
    }
    
    func setSaveBarButton(){
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self , action: #selector(AgregarPropietario.saveProduct))
        navigationItem.rightBarButtonItem = saveBarButton //Creamos el botn de Guardar
    }
    
    func saveProduct(){
        
        
        //Verifcamos que ningun campo este vacio
        if (txfCurp.text?.isEmpty)! || (txfNombre.text?.isEmpty)! || (txfApPater.text?.isEmpty)! || (txfApeMat.text?.isEmpty)! || (txfDescripcion.text?.isEmpty)! || (txfTelefono.text?.isEmpty)! || tipoSexo.isEmpty || (txfEmail.text?.isEmpty)! || fotoPropietario.image == nil{
            
            let alertController = UIAlertController(title: "Advertencia", message: "Verifica los datos, Algunos estan vacios", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }
       
        
        else{
            if (txfLatitud.text?.isEmpty)! || (txfLongitud.text?.isEmpty)!{
                /*let alertController = UIAlertController(title: "Informacion", message: "No se eligio ninguna direccion, se asignara una por defecto", preferredStyle: .alert)
                 alertController.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
                 self.present(alertController, animated: true, completion: nil)*/
                
                txfLatitud.text = "16.7569494180683"
                txfLongitud.text = "-93.1722394986428"
            }
            
            let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Duenio")
            fetchrequest.predicate = NSPredicate(format: "curp == %@",txfCurp.text!)
            do{
                let result = try managedObjectContext.fetch(fetchrequest)
                
                if result.count > 0 {
                    let alertController = UIAlertController(title: "Advertencia", message: "La curp que intenta registrar, ya se encuentra en la BD", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                else{
                    
                    //Imprimimos los datos
                    //print("Propietario Guardado: \(txfCurp.text!), \(txfNombre.text!), \(txfApPater.text!), \(txfApeMat.text!), \(txfCalle.text!), \(txfColonia.text!), \(txfCiudad.text!), \(txfCPostal.text!), \(txfTelefono.text!), \(tipoSexo), \(txfEmail.text!)")
                    
                    //Aqui insertamos en la Base de Datos
                    
                    let propientity = NSEntityDescription.entity(forEntityName:"Duenio", in: managedObjectContext)
                    let propier = Duenio(entity: propientity!, insertInto:managedObjectContext)
                    
                    //Agregamos los valores de los textfield a la entidad de Propietarios
                    propier.curp = txfCurp.text!
                    propier.nombre = txfNombre.text!
                    propier.apePat = txfApPater.text!
                    propier.apeMat = txfApeMat.text!
                    propier.latitud = txfLatitud.text!
                    propier.longitud = txfLongitud.text!
                    propier.descripcion = txfDescripcion.text!
                    //propier.idPropier = txfCPostal.text!
                    propier.telefono = txfTelefono.text!
                    propier.correo = txfEmail.text!
                    propier.sexo = tipoSexo
                    
                    if let data = UIImageJPEGRepresentation(self.fotoPropietario.image!, 1.0){
                        propier.foto = data as NSData
                    }
                    
                    guardarDatosCoreData(){ //Funcion para insertar y luego regresar al lista
                        self.navigationController!.popToRootViewController(animated: true)
                    }
                }
            }catch let error as NSError{
                print("Error al realizar la consulta \(error)")
            }
        }
    }
    
    
    func guardarDatosCoreData(completion: @escaping ()->Void){ //Funcion que guarda los datos
        
            managedObjectContext.perform{
                do{
                    try self.managedObjectContext.save()
                    completion()
                    print("Propietario guardado ")
                } catch  {
                    print("No se pudo guardar los registros: \(error.localizedDescription)")
                }

                
            }
            
    }
    
    
    @IBAction func tapObtenerFotoPropietario(_ sender: UITapGestureRecognizer) { //Funcion que Al dar sobre la imagen se crea el menu para elegir la foto
        
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
            self.fotoPropietario.image = image //Obtenemos la imagen y se la ponemos al ImageView
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //En caso de cancelar, no coloca nada en el imageview
        picker.dismiss(animated: true, completion: nil)
    }
    
  

}
