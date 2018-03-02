//
//  ListaPropierTableViewCell.swift
//  consecionariaAutos
//
//  Created by Benjamin on 5/31/17.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import UIKit
import CoreData

class ListaPropierTableViewCell: UITableViewCell {

    @IBOutlet var imagePropietario: UIImageView!
    @IBOutlet var namePropietario: UILabel!
    @IBOutlet var apellidoPropietario: UILabel!
    @IBOutlet var phonePropietario: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configuracionCelda(propier: Duenio){ //Cargamos los datos a la celda personalizada
        imagePropietario.layer.cornerRadius = 34
        imagePropietario.layer.masksToBounds = true
        self.namePropietario.text = " \(propier.nombre!)"
        self.apellidoPropietario.text = "\(propier.apePat!) \(propier.apeMat!)"
        self.phonePropietario.text = "\(propier.telefono!)"
        self.imagePropietario.image = UIImage(data: propier.foto as! Data)
    }

}
