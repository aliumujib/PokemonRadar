//
//  NavBarController.swift
//  Awesome Notes
//
//  Created by Abdul-Mujib Aliu on 5/7/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import UIKit


class NavBarController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //Make color of title
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.navigationBar.tintColor = .white
        self.navigationBar.isTranslucent = false
        
        self.navigationBar.barTintColor = PRIMARY_COLOR
    
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
