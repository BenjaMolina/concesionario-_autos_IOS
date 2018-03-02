//
//  ConsultasBD.swift
//  consecionariaAutos
//
//  Created by Benjamin on 6/3/17.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import UIKit
import CoreData

class ConsultasBD{
    
    var managedObjecContext:NSManagedObjectContext
    
    init() {
        self.managedObjecContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func extraerPropietariosCoreData() -> [Duenio]?{
        var result = [Duenio]()
        let request: NSFetchRequest<Duenio> = Duenio.fetchRequest()
        do {
            result = try managedObjecContext.fetch(request)
           
        }catch {
            print("No se pudieron extraer los datos: \(error.localizedDescription)")
        }
        
         return result  //Devuelve la consulta de todos lo elementos que se encuentren en la entidad Duenio
        
    }
    
    func numeroAutos(propier: Duenio) -> Int{
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Duenio")
         
         fetchRequest.predicate = NSPredicate(format: "curp == %@", propier.curp!) //consulta
        
         do{
            let results = try managedObjecContext.fetch(fetchRequest)
            if results.count > 0{
                let p = results.first! as! Duenio
         
                if let propie = p.esPropietario{
                   
                    for c in propie{
                        let c = c as! Auto
                        print("Coche de \(c.marca) - \(c.tipo)")
                    }
                    
                    return  (p.esPropietario?.count)!
                    
                }
            }else{
                print("No hay personas")
                return 0
            }
         }catch let error as NSError{
            print("Error al consultar \(error)")
         }
        
        return 0

    }
    
    func obtenerAutosDuenios(propier: Duenio) -> [Auto]?{
        
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Auto")
        fetchRequest.predicate = NSPredicate(format: "peretenece.curp == %@",propier.curp!)
        do {
            let results = try managedObjecContext.fetch(fetchRequest)
                let autosEncontrados: [Auto]? = results as? [Auto]
                if (autosEncontrados?.count)! > 0 {
                    print("----------------------------------------------------")
                    print("\(autosEncontrados?.count) Autos")
                    print("\(autosEncontrados?[0].nSerie)")
                    print("con propietario: \(propier.nombre)")
                    print("----------------------------------------------------")
            }
            return autosEncontrados
            
        }
        catch {
            fatalError("There was an error fetching the items")
        }
        
        return nil

        /*let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Duenio")
        
        fetchRequest.predicate = NSPredicate(format: "curp == %@", propier.curp!) //consulta
    
        do{
            let results = try managedObjecContext.fetch(fetchRequest)
            if results.count > 0{
                let p = results.first! as! Duenio
                
                if let propie = p.esPropietario{
                    
                    //let autosss = p.esPropietario?.allObjects as! Auto
                    for c in propie{
                        
                        let c = c as! Auto
                        print("Coche de \(c.marca) - \(c.tipo)")
                        
                    }
                    
                    //return autosss

                }
            }else{
                print("No hay personas")
                //return nil
            }
        }catch let error as NSError{
            print("Error al consultar \(error)")
        }*/
        
        //return nil
        
    }


}
