//
//  AgregarAutoTableViewController.swift
//  consecionariaAutos
//
//  Created by Benjamin on 6/2/17.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import UIKit
import CoreData


class AgregarAutoTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var datosEditarAuto:Auto? = nil
    var tipoSegui:String? = nil
    var propietariosArray = [Duenio]()
    var cochCamio = "Camioneta"
    var puertas = 4
    var duenioAuto:Duenio? = nil
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var imagenAuto: UIImageView!
    @IBOutlet var txfMarca: UITextField!
    @IBOutlet var txfModelo: UITextField!
    @IBOutlet var txfSerie: UITextField!
    @IBOutlet var txfMotor: UITextField!
    @IBOutlet var nPuertas: UISwitch!
    @IBOutlet var txfKilometros: UITextField!
    @IBOutlet var txfPrecio: UITextField!
    @IBOutlet var kmReco: UISlider!
    @IBOutlet var precio: UISlider!
    @IBOutlet var tipoCoche: UISwitch!
    @IBOutlet var txfDescription: UITextView!
    @IBOutlet var pickerPropietario: UIPickerView!
    
    @IBOutlet var txfMuestraTipoCoche: UITextField!
    @IBOutlet var txfMuestraPueetas: UITextField!
    
    
    @IBAction func numeroPuertas(_ sender: UISwitch) {
        
        if nPuertas.isOn {
            puertas = 4
            txfMuestraPueetas.text = "4 Puertas"
        }
            
        else{
            puertas = 2
            txfMuestraPueetas.text = "2 Puertas"
        }
        
    }

    @IBAction func kmRecorridos(_ sender: Any) {
        txfKilometros.text = String(kmReco.value)
    }
    
    @IBAction func cohceCam(_ sender: UISwitch) {
        
        if tipoCoche.isOn {
            cochCamio = "Camioneta"
            txfMuestraTipoCoche.text = "Camioneta"
        }
            
        else{
            cochCamio = "Coche"
            txfMuestraTipoCoche.text = "Coche"
        }

    }
    
    @IBAction func obtenerPRecio(_ sender: UISlider) {
        txfPrecio.text = String(precio.value)
        
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AgregarAutoTableViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        print("Tipo de Segui:  \(tipoSegui)")
        
        if tipoSegui == "editar"{ //Si es del tipo editar, cargamos todos los datos
            
            
            
            imagenAuto.image = UIImage(data: datosEditarAuto?.imagen as! Data)
            txfMarca.text = datosEditarAuto?.marca
            txfModelo.text = String((datosEditarAuto?.modelo)!)
            txfSerie.text  = datosEditarAuto?.nSerie
            txfMotor.text  = datosEditarAuto?.nMotor
            txfMuestraPueetas.text  = (String((datosEditarAuto?.nPuertas)!) + " Puertas")
            if datosEditarAuto?.nPuertas == 2{nPuertas.isOn = false} else{ nPuertas.isOn = true}
            if datosEditarAuto?.tipo == "Camioneta"{tipoCoche.isOn = true} else{
                tipoCoche.isOn = false
            }
            txfMuestraTipoCoche.text = datosEditarAuto?.tipo
            txfKilometros.text  = datosEditarAuto?.kmRecorri
            txfPrecio.text  = datosEditarAuto?.precio
            txfDescription.text  = datosEditarAuto?.descripcion
            
            kmReco.value = Float((datosEditarAuto?.kmRecorri)!)!
            precio.value = Float((datosEditarAuto?.precio)!)!
            
            updateSaveBarButton() //Creamos el boton de Guardar
            
        }
        else{
            txfMuestraTipoCoche.text = "Camioneta"
            txfMuestraPueetas.text = "4 Puertas"
            
            if(propietariosArray.count == 0){
                pickerPropietario.isHidden = true
            }else{
                duenioAuto = propietariosArray[0]
            }
           
            
            txfKilometros.text = String(kmReco.value)
            txfPrecio.text = String(precio.value)
            
            setSaveBarButton() //Creamos el boton de Guardar

        }
        self.pickerPropietario.dataSource = self
        self.pickerPropietario.delegate = self
        recuperarPropietarios()
        
        
    }
    
    
    
    func setSaveBarButton(){ //Funcion para crear boton
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self , action: #selector(AgregarAutoTableViewController.saveAuto))
        navigationItem.rightBarButtonItem = saveBarButton //Creamos el botn de Guardar
    }
    
    func updateSaveBarButton(){
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self , action: #selector(AgregarAutoTableViewController.updateAuto))
        navigationItem.rightBarButtonItem = saveBarButton //Creamos el botn de Update
    }

    
    
    //-----------------Todo esto es para lo de recuperar Propietarios--------
    
    override func viewWillAppear(_ animated: Bool) {
        /*if tipoSegui == "editar"{
            recuperarPropierAuto()
        }
        else{*/
            recuperarPropietarios()
            if(propietariosArray.count == 0){
                let alertController = UIAlertController(title: "Advertencia", message: "No puedes Agregar Autos sin primero haber agregado un Propietario!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
            }
            if(propietariosArray.count == 0){
                pickerPropietario.isHidden = true
            }
            else{
                pickerPropietario.isHidden = false
                duenioAuto = propietariosArray[0]
            }
        
        if tipoSegui == "editar"{
            recuperarPropierAuto()
        }
        //}
       
    }
    
    func recuperarPropietarios(){
        extraerPropietariosCoreData{ (propier) in
            if let propier = propier{
                self.propietariosArray = propier //Agrega los datos extraidos de la consulta al array para mostrarlo en consulta
                
            }
            
        }
        
    }
    
    func extraerPropietariosCoreData(completion: ([Duenio]?)-> Void){
        var result = [Duenio]()
        let request: NSFetchRequest<Duenio> = Duenio.fetchRequest()
        do {
            result = try managedObjectContext.fetch(request)
            completion(result) //Devuelve la consulta de todos lo elementos que se encuentren en la entidad Duenio
        }catch {
            print("No se pudieron extraer los datos: \(error.localizedDescription)")
        }
    }
    
    
    
    func recuperarPropierAuto(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Auto")
        
        fetchRequest.predicate = NSPredicate(format: "nSerie == %@", (datosEditarAuto?.nSerie!)!) //consulta
        
        
        do{
            let results = try managedObjectContext.fetch(fetchRequest)
            if results.count > 0{
                let p = results.first! as! Auto
                
                print(p)
                
                if let propie = p.peretenece{
                    print("\(propie.nombre!)")
                    print("NUMERO DE PERSONSAS\(propietariosArray.count)")
                    for i in 0..<propietariosArray.count{
                        
                        if(propietariosArray[i].nombre == propie.nombre){
                            print("INCREMENRO: \(i)")
                            duenioAuto = propietariosArray[i]
                            pickerPropietario.selectRow(i, inComponent: 0, animated: false)
                            
                        }
                    }
                }
            }else{
                print("No hay personas")
                pickerPropietario.isHidden = true
            }
        }catch let error as NSError{
            print("Error al consultar \(error)")
            
        }
        

    }

    //-----------------Termina lo de recuperar propietario----------------
    
     /*
     -------------Esto es lo del Picker-------------------------------------
     */
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return propietariosArray.count //El Viewcontroller ya sabe cuantos datos tendra el Picker
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return (propietariosArray[row].nombre! + " " + propietariosArray[row].apePat!)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //Retornamos solo una columna,
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
       duenioAuto = propietariosArray[row]
       print("Nombre del Propietario: \(duenioAuto)")
        print("Selected Rowww: \(row)")
    }

    //------------------------Aqui termina lo del Picker--------------------------------//
    
    
    
    //------------------------Comienza la funcion de insertar Auto-----------------------//
    func saveAuto(){
        
        if(propietariosArray.count == 0){
            let alertController = UIAlertController(title: "Advertencia", message: "No puedes Agregar Autos sin primero haber agregado un Propietario!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
        else{
            print("Los valores son: \(txfMarca.text),  \(txfModelo.text) \(txfSerie.text),  \(txfMotor.text) \(txfKilometros.text),  \(txfPrecio.text) \(txfDescription.text),  \(imagenAuto)")
            //Verifcamos que ningun campo este vacio
            if (txfMarca.text?.isEmpty)! || (txfModelo.text?.isEmpty)! || (txfSerie.text?.isEmpty)! || (txfMotor.text?.isEmpty)!  || (txfKilometros.text?.isEmpty)! || (txfPrecio.text?.isEmpty)! || (txfDescription.text?.isEmpty)! || imagenAuto.image == nil || duenioAuto == nil{
                
                let alertController = UIAlertController(title: "Advertencia", message: "Verifica los datos, Algunos estan vacios", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                
            }
                
            else{
                print("Volvio a pasar")
                let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Auto")
                fetchrequest.predicate = NSPredicate(format: "nSerie == %@",txfSerie.text!)
                do{
                    let result = try managedObjectContext.fetch(fetchrequest)
                    
                    if result.count > 0 {
                        let alertController = UIAlertController(title: "Advertencia", message: "El numero de Serie que intenta registrar, ya se encuentra en la BD", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    else{
                        
                        //Aqui insertamos en la Base de Datos
                        
                        let propientity = NSEntityDescription.entity(forEntityName:"Auto", in: managedObjectContext)
                        
                        let autonuevo = Auto(entity: propientity!, insertInto:managedObjectContext)
                        
                        //Agregamos los valores de los textfield a la entidad de Propietarios
                        autonuevo.descripcion = txfDescription.text!
                        autonuevo.kmRecorri = (txfKilometros.text!)
                        autonuevo.marca = txfMarca.text!
                        autonuevo.modelo = Int16(txfModelo.text!)!
                        autonuevo.nMotor = txfMotor.text!
                        autonuevo.nPuertas = Int16(puertas)
                        autonuevo.nSerie = txfSerie.text!
                        autonuevo.precio = (txfPrecio.text!)
                        autonuevo.tipo = cochCamio
                        
                        if let data = UIImageJPEGRepresentation(self.imagenAuto.image!, 1.0){
                            autonuevo.imagen = data as NSData
                        }
                        
                        autonuevo.peretenece = duenioAuto //Insertamos en la relacion
                        
                        print(autonuevo)
                        
                        do{
                            try managedObjectContext.save()
                            print("Se inserto registro \(autonuevo)")
                            self.navigationController!.popToRootViewController(animated: true)
                        }catch let error as NSError{
                            print("Error al insertar \(error)")
                        }
                    }
                }catch let error as NSError{
                    print("Error al realizar la consulta \(error)")
                }
                
                
                
            }

        }
            
    }
    
    
    
    //-------------------------Termina funciopn de insertar-------------------------------------//
    
    
    
     //------------------------Comienza la funcion de insertar Auto-----------------------//
    
    
    
    
    
    
     //-------------------------Termina funciopn de Update-------------------------------------//
    
    
    func updateAuto(){
        
        //print("Los valores son: \(txfMarca.text),  \(txfModelo.text) \(txfSerie.text),  \(txfMotor.text) \(txfKilometros.text),  \(txfPrecio.text) \(txfDescription.text),  \(imagenAuto)")
        //Verifcamos que ningun campo este vacio
        if (txfMarca.text?.isEmpty)! || (txfModelo.text?.isEmpty)! || (txfSerie.text?.isEmpty)! || (txfMotor.text?.isEmpty)!  || (txfKilometros.text?.isEmpty)! || (txfPrecio.text?.isEmpty)! || (txfDescription.text?.isEmpty)! || imagenAuto.image == nil || duenioAuto == nil{
            
            let alertController = UIAlertController(title: "Advertencia", message: "Verifica los datos, Algunos estan vacios", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            
        }else{
            if txfSerie.text! != datosEditarAuto?.nSerie
            { //Se hace la consulta para ver si no existe el numSerie
                let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Auto")
                fetchrequest.predicate = NSPredicate(format: "nSerie == %@",txfSerie.text!)
                do{
                    let result = try managedObjectContext.fetch(fetchrequest)
                    
                    if result.count > 0 { //Sie xiste
                        let alertController = UIAlertController(title: "Advertencia", message: "El numero de Serie que intenta registrar, ya se encuentra en la BD", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "Aceptar", style: .cancel, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    else{
                        //Actualziamos en la Base de Datos
                        datosEditarAuto?.descripcion = txfDescription.text!
                        datosEditarAuto?.kmRecorri = (txfKilometros.text!)
                        datosEditarAuto?.marca = txfMarca.text!
                        datosEditarAuto?.modelo = Int16(txfModelo.text!)!
                        datosEditarAuto?.nMotor = txfMotor.text!
                        datosEditarAuto?.nPuertas = Int16(puertas)
                        datosEditarAuto?.nSerie = txfSerie.text!
                        datosEditarAuto?.precio = (txfPrecio.text!)
                        datosEditarAuto?.tipo = cochCamio
                        
                        if let data = UIImageJPEGRepresentation(self.imagenAuto.image!, 1.0){
                            datosEditarAuto?.imagen = data as NSData
                        }
                        
                        datosEditarAuto?.peretenece = duenioAuto //Insertamos en la relacion
                        
                        print("\(datosEditarAuto)")
                        do{
                            try managedObjectContext.save()
                            print("Se edito registro")
                            self.navigationController!.popToRootViewController(animated: true)
                        }catch let error as NSError{
                            print("Error al insertar \(error)")
                        }
                    }

                }catch let error as NSError{
                    print("Error al realizar la consulta \(error)")
                }
            }
            else
            { //Si no cambio el nSerie (id), se hara un update a el mismo
                //Actualziamos en la Base de Datos
                datosEditarAuto?.descripcion = txfDescription.text!
                datosEditarAuto?.kmRecorri = (txfKilometros.text!)
                datosEditarAuto?.marca = txfMarca.text!
                datosEditarAuto?.modelo = Int16(txfModelo.text!)!
                datosEditarAuto?.nMotor = txfMotor.text!
                datosEditarAuto?.nPuertas = Int16(puertas)
                datosEditarAuto?.nSerie = txfSerie.text!
                datosEditarAuto?.precio = (txfPrecio.text!)
                datosEditarAuto?.tipo = cochCamio
                
                if let data = UIImageJPEGRepresentation(self.imagenAuto.image!, 1.0){
                    datosEditarAuto?.imagen = data as NSData
                }
                
                datosEditarAuto?.peretenece = duenioAuto //Insertamos en la relacion
                
                print("\(datosEditarAuto)")
                do{
                    try managedObjectContext.save()
                    print("Se edito registro")
                    self.navigationController!.popToRootViewController(animated: true)
                }catch let error as NSError{
                    print("Error al insertar \(error)")
                }
            }
        }
        

    }

    
    
    
    
    
    //-----------Manejo de la Seleccion de la imagen --------
    
    
    @IBAction func obtenerImagen(_ sender: UITapGestureRecognizer) {
        //Funcion que Al dar sobre la imagen se crea el menu para elegir la foto
        
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
            self.imagenAuto.image = image //Obtenemos la imagen y se la ponemos al ImageView
        }
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //En caso de cancelar, no coloca nada en el imageview
        picker.dismiss(animated: true, completion: nil)
    }

    
    }
    
    


