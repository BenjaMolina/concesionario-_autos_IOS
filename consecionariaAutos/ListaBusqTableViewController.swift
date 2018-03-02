//
//  ListaBusqTableViewController.swift
//  consecionariaAutos
//
//  Created by Benjamin on 6/3/17.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import UIKit
import CoreData


class ListaBusqTableViewController: UITableViewController {

    var propietariosArray = [Duenio]()
    let listaPropietarios = ConsultasBD()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        recuperarPropietarios()
    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return propietariosArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellBusqueda", for: indexPath) as! ListaBusquedaTableViewCell
        
        cell.configuracionCeldaBusqueda(propier: propietariosArray[indexPath.row])

        return cell
    }

    
    func recuperarPropietarios(){
        propietariosArray = listaPropietarios.extraerPropietariosCoreData()!
        print(propietariosArray)
        self.tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //preparando los datos a mandar Segui
        if segue.identifier == "seguiCollection"{
            
            guard let viewcontroller = segue.destination as? CollectionViewController else {return}
            
            guard let indexpath = tableView.indexPathForSelectedRow else {return}
            guard let cochesDuenios = listaPropietarios.obtenerAutosDuenios(propier: propietariosArray[indexpath.row]) else {return}
            viewcontroller.autoDueniosArray = cochesDuenios
            
        }

    }

}
