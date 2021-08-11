//
//  UpgradeControllerV2.swift
//  System of Equations
//
//  Created by Brian Veitch on 1/1/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import StoreKit

class UpgradeControllerV2: UIViewController {

    var products: [SKProduct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IAPProducts.store.requestProducts{ [weak self] success, products in
          guard let self = self else { return }
            if success {
                self.products = products!
            }
        }
    
    }
    
    
    @IBAction func puchaseButton(_ sender: Any) {
        print("Trying to purchase")
        // filter through products
        IAPProducts.store.purchaseProduct(products, IAPProducts.instantSolution)
    }
    
}
