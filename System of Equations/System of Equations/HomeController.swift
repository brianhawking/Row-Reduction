//
//  HomeController.swift
//  System of Equations
//
//  Created by Brian Veitch on 12/6/19.
//  Copyright © 2019 Brian Veitch. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    var menuShowing: Bool = false
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet var onScreenButtons: [UIButton]!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuView.layer.shadowOpacity = 0
        menuView.layer.shadowRadius = 6
        
//        for button in onScreenButtons {
//            button.layer.cornerRadius = 10
//            button.layer.borderWidth = 1
//            button.layer.borderColor = UIColor.black.cgColor
//        }
        
        

    }
    

    @IBAction func openMenu(_ sender: Any) {
        
        
        if (menuShowing) {
            // hide menu
            leadingConstraint.constant = -175
            menuView.layer.shadowOpacity = 0
            mainView.layer.opacity = 1
        }
        else {
            leadingConstraint.constant = 0
            menuView.layer.shadowOpacity = 1
            mainView.layer.opacity = 0.5
            
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        menuShowing = !menuShowing
        
    }
    
}
