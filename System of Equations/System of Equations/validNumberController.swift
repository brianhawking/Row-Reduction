//
//  validNumberController.swift
//  System of Equations
//
//  Created by Brian Veitch on 12/20/19.
//  Copyright © 2019 Brian Veitch. All rights reserved.
//

import UIKit

class validNumberController: UIViewController {

    
    @IBOutlet weak var messageLabel: UILabel!
    var message: String = ""
    
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messageLabel.text! = message
        
    }
    
    @IBAction func dismissMessage(_ sender: Any) {
        dismiss(animated: true)
        
    }
    

}
