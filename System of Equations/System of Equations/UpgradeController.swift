//
//  UpgradeController.swift
//  System of Equations
//
//  Created by Brian Veitch on 12/31/19.
//  Copyright © 2019 Brian Veitch. All rights reserved.
//

import UIKit
import StoreKit

class UpgradeController: UIViewController, SKPaymentTransactionObserver {

    

    let productID = "com.brianveitch.RowReducton.Test"
    
    @IBOutlet weak var puchaseButton: CommonButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.default().add(self)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func purchaseButton(_ sender: Any) {
        
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        }
        else {
            print("user unable to make payments")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                // item is purchased
                print("transaction successful")
                puchaseButton.setTitle("Purchased!", for: .normal)
            }
            else if transaction.transactionState == .failed {
                print("transaction failed")
            }
        }
    }
    
    
}
