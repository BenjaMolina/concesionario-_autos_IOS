//
//  ListaBusquedaTableViewCell.swift
//  consecionariaAutos
//
//  Created by Benjamin on 6/3/17.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import UIKit
import CoreData

class ListaBusquedaTableViewCell: UITableViewCell {
    
    let consulta = ConsultasBD()

    @IBOutlet var imageCatalago: UIImageView!
    @IBOutlet var catalagoNombre: UILabel!
    @IBOutlet var catApe: UILabel!
    @IBOutlet var catNumero: UILabel!
    @IBOutlet var catCantAutos: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func configuracionCeldaBusqueda(propier: Duenio){ //Cargamos los datos a la celda personalizada
        
        let numeroAutos = consulta.numeroAutos(propier: propier)
        
        imageCatalago.layer.cornerRadius = 40
        imageCatalago.layer.masksToBounds = true
        self.catalagoNombre.text = " \(propier.nombre!)"
        self.catApe.text = "\(propier.apePat!)"
        self.catNumero.text = "\(propier.telefono!)"
        self.catCantAutos.text = "\(numeroAutos) Autos"
        self.imageCatalago.image = UIImage(data: propier.foto as! Data)
        print("Entrooooooo")
    }


}
