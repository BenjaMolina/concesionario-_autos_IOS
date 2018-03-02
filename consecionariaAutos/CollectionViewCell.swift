//
//  CollectionViewCell.swift
//  consecionariaAutos
//
//  Created by Benjamin on 6/3/17.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imagAuto: UIImageView!
    @IBOutlet var visualColec: UIVisualEffectView!
    @IBOutlet var lblColect: UILabel!
    
    func configuraColecCell(auto: Auto){
        if auto.imagen != nil{
            self.imagAuto.image = UIImage(data: auto.imagen as! Data)
            self.lblColect.text = " \(auto.marca!)"
        }
        else {
            print("No tiene Ningun carrro este men!!")
        }
    }
}
