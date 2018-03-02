//
//  ListaAautos.swift
//  consecionariaAutos
//
//  Created by Benjamin on 6/2/17.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import UIKit
import CoreData

class ListaAautos: UITableViewController {
    
    var autosArray = [Auto]()
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return autosArray.count
    }
    
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellAutos", for: indexPath) as! AutosTableViewCell
        
        cell.configuracionCelda(auto: autosArray[indexPath.row])
        //print("SRecargado2")
        //print(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            print("Eliminando : \(autosArray[indexPath.row])")
            
            managedObjectContext.delete(autosArray[indexPath.row])
            
            do{
                try managedObjectContext.save()
                print("Eliminando registro....")
            }catch let error as NSError{
                print("Error al eliminar: \(error)")
            }
            autosArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    
    override func viewWillAppear(_ animated: Bool) { //Se ejecuta cada vez que aparece el tableView, es diferente al ViewDidload
        super.viewWillAppear(true)
        recuperarAutos()

    }
    
    func recuperarAutos(){
        extraerAutosCoreData{ (propier) in
            if let propier = propier{
                self.autosArray = propier //Agrega los datos extraidos de la consulta al array para mostrarlo en consulta
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    func extraerAutosCoreData(completion: ([Auto]?)-> Void){
        var result = [Auto]()
        let request: NSFetchRequest<Auto> = Auto.fetchRequest()
        do {
            result = try managedObjectContext.fetch(request)
            completion(result) //Devuelve la consulta de todos lo elementos que se encuentren en la entidad Duenio
        }catch {
            print("No se pudieron extraer los datos: \(error.localizedDescription)")
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //Preparando los datos a mandar Segui
        if segue.identifier == "editarAuto"{
            
            guard let viewcontroller = segue.destination as? AgregarAutoTableViewController else {return}
            
            guard let indexpath = tableView.indexPathForSelectedRow else {return}
            let autocoche = autosArray[indexpath.row]
            viewcontroller.datosEditarAuto = autocoche
            viewcontroller.tipoSegui = "editar"
            
        }
            
    }
    
    @IBAction func regresarListaAutos(segue: UIStoryboard){
        //Funcion solo para regresar esta pantalla
    }


    
 
 
 }
