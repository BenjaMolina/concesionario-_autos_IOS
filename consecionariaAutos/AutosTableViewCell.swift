//
//  AutosTableViewCell.swift
//  consecionariaAutos
//
//  Created by Benjamin on 6/2/17.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import UIKit
import CoreData

class AutosTableViewCell: UITableViewCell {

    @IBOutlet var imagenAuto: UIImageView!
    @IBOutlet var marcaAuto: UILabel!
    @IBOutlet var modeloAuto: UILabel!
    @IBOutlet var kmAuto: UILabel!
    @IBOutlet var propietarioAuto: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configuracionCelda(auto: Auto){ //Cargamos los datos a la celda personalizada
        
        
        /*let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Auto")
        
        fetchRequest.predicate = NSPredicate(format: "nSerie == %@", auto.nSerie!) //consulta
        

        do{
            let results = try managedObjectContext.fetch(fetchRequest)
            if results.count > 0{
                let p = results.first! as! Auto
                
                if let propie = p.peretenece{
                    print("PErtence a \(propie.nombre)")
                    self.marcaAuto.text = " \(auto.marca!)"
                    self.modeloAuto.text = "\(auto.modelo)"
                    self.kmAuto.text = "\(auto.kmRecorri!)"
                    self.propietarioAuto.text = "\(propie.nombre!)"
                    self.imagenAuto.image = UIImage(data: auto.imagen as! Data)
                }
            }else{
                print("No hay personas")
            }
        }catch let error as NSError{
            print("Error al consultar \(error)")
            
        }*/
        imagenAuto.layer.cornerRadius = 10
        imagenAuto.layer.masksToBounds = true
        
        self.marcaAuto.text = " \(auto.marca!)"
        self.modeloAuto.text = "Mod. \(auto.modelo)"
        self.kmAuto.text = "\(auto.kmRecorri!) KM"
        self.propietarioAuto.text = "\(auto.nPuertas) puertas"
        self.imagenAuto.image = UIImage(data: auto.imagen as! Data)


        
    }

}
