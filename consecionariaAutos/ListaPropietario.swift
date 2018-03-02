//
//  ListaPropietario.swift
//  consecionariaAutos
//
//  Created by Benjamin on 5/31/17.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import UIKit
import CoreData

enum indeceSeleccionado:Int{
    case named = 0
    case curpi = 1
}

class ListaPropietario: UITableViewController,UISearchBarDelegate {
    
    var propietariosArray = [Duenio]()
    
    var managedObjecContext: NSManagedObjectContext { //otra forma de crear el manejador de contexto
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        AgregarPropietario.direccionLongitud = 0.0
        AgregarPropietario.direccionLongitud  = 0.0
        
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
        //self.crearBarraBusqueda() //Creamos en la cabezera la barra de busquedas
        
    }
    
    func crearBarraBusqueda(){ //Funcion para crear la barra de busqueda
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: (UIScreen.main.bounds.width), height: 70)) //Colocamos los paramtros del tamaño que tendra
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles =  ["Nombre","CURP"] //Colocamos los tipos de filtros que tendra
        
        searchBar.delegate = self
        self.tableView.tableHeaderView = searchBar //Colcamos la barra de busqueda en la cabeecera

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) { //MEtodo para comenzar a realizar la busqueda
        if searchText.isEmpty{
            recuperarPropietarios()
            self.tableView.reloadData()
        }
        
        filtradoBusqueda(indice: searchBar.selectedScopeButtonIndex, text:searchText) //Obtenemos el valor del index que se haya seleccionado en las opciones (0=Nombre, 1=CURP) y lo Mandamos a la funcion de filtradoBusqueda()
    }
    
    func filtradoBusqueda(indice:Int, text:String){ //Funcion que recibe el valor de index seleccionado para la busqueda
        switch indice {
        case indeceSeleccionado.named.rawValue:
            print(propietariosArray.filter({(mod)-> Bool in return (mod.nombre?.contains(text))!}))
            _ = propietariosArray.filter({(mod)-> Bool in return (mod.nombre?.contains(text))!})
            self.tableView.reloadData()
        case indeceSeleccionado.curpi.rawValue:
            print(propietariosArray.filter({(mod)-> Bool in return (mod.curp?.contains(text))!})
)
            _ = propietariosArray.filter({(mod)-> Bool in return (mod.curp?.contains(text))!})
            self.tableView.reloadData()
        default:
            print("No se eligio ninguna opcion")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) { //Se ejecuta cada vez que aparece el tableView, es diferente al ViewDidload
        super.viewWillAppear(true)
        recuperarPropietarios()
        print("Aqie merosadsas")
        AgregarPropietario.direccionLatitud = 0.0
        AgregarPropietario.direccionLongitud  = 0.0
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
        return propietariosArray.count
    }

    let cellId = "cellPropietaro"
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ListaPropierTableViewCell
        //cell.layer.cornerRadius = 10
        cell.configuracionCelda(propier: propietariosArray[indexPath.row])
        //print("SRecargado2")
        //print(cell)
        return cell
    }
    
    func recuperarPropietarios(){
        extraerPropietariosCoreData{ (propier) in
            if let propier = propier{
                self.propietariosArray = propier //Agrega los datos extraidos de la consulta al array para mostrarlo en consulta
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    func extraerPropietariosCoreData(completion: ([Duenio]?)-> Void){
        var result = [Duenio]()
        let request: NSFetchRequest<Duenio> = Duenio.fetchRequest()
        do {
            result = try managedObjecContext.fetch(request)
            completion(result) //Devuelve la consulta de todos lo elementos que se encuentren en la entidad Duenio
        }catch {
            print("No se pudieron extraer los datos: \(error.localizedDescription)")
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
           print("Eliminando : \(propietariosArray[indexPath.row])")
            
           managedObjecContext.delete(propietariosArray[indexPath.row])
            
            do{
                try managedObjecContext.save()
                print("Eliminando registro....")
            }catch let error as NSError{
                print("Error al eliminar: \(error)")
            }
            propietariosArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "seguiEditar"{
            
            let viewController:EditarPropietarioTableViewController = segue.destination as! EditarPropietarioTableViewController
            
            //guard let viewController =  segue.source as? EditarPropietarioTableViewController else {return}
            guard let indexpath = tableView.indexPathForSelectedRow else {return}
            
            //print(indexpath)
            
            let propier = propietariosArray[indexpath.row]
            viewController.propier = propier
            
            //print(propier)
        }
            
            
        }
    
    
}
