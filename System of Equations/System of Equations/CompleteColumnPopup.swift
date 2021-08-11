//
//  CompleteColumnPopup.swift
//  System of Equations
//
//  Created by Brian Veitch on 12/15/19.
//  Copyright © 2019 Brian Veitch. All rights reserved.
//

import UIKit

class CompleteColumnPopup: UIViewController {

    
    @IBOutlet weak var viewPopUp: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    var message: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton.layer.cornerRadius = 10
        dismissButton.layer.borderWidth = 1
       
        messageLabel.text! = message

    }
    

    
    @IBAction func dismissMessage(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
