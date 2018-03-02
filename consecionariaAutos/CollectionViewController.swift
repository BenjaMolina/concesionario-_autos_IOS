//
//  CollectionViewController.swift
//  consecionariaAutos
//
//  Created by Benjamin on 6/3/17.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import UIKit


class CollectionViewController: UICollectionViewController {
    
    var autoDueniosArray:[Auto]? = nil
    
    private let leftAndRightPaddings:CGFloat = 26.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    private let heigthAdjustment:CGFloat = 30.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = ((collectionView?.frame)!.width - leftAndRightPaddings) / numberOfItemsPerRow
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width + heigthAdjustment)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return autoDueniosArray!.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellImagenAuto", for: indexPath) as! CollectionViewCell
        
        cell.layer.cornerRadius = 6
        if autoDueniosArray?.count != 0 {
            cell.configuraColecCell(auto: (autoDueniosArray?[indexPath.row])!)
        }
        
        print("Paso la creacion del catalago de coches")
        return cell
    }

}
