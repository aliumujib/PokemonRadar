//
//  SelectorCollectionViewController.swift
//  PokemonRadar
//
//  Created by Abdul-Mujib Aliu on 6/3/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SelectorCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: PokemonSelectedDelegate?

    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        screenWidth = self.view.frame.size.width
        screenHeight = self.view.frame.size.height
        
        if let barBtnItem = self.navigationController?.navigationBar.topItem{
            barBtnItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }

        self.title = "Select"

        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.setSelectedPokemon(pokeId: indexPath.row) //offset by 1
    
       _ = self.navigationController?.popViewController(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pokemon.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SELECTOR_CELL_REUSE_ID, for: indexPath) as! SelectorCollectionViewCell
    
        cell.bindPokemon(pokeId: indexPath.row)
        
        // Configure the cell
    
        return cell
    }


}
