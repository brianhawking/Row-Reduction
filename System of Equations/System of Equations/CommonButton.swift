//
//  CommonButton.swift
//  System of Equations
//
//  Created by Brian Veitch on 12/17/19.
//  Copyright © 2019 Brian Veitch. All rights reserved.
//

import Foundation
import UIKit

class CommonButton : UIButton {

   override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
      }

   required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
      }

    func setup() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
      }
    
    

}
