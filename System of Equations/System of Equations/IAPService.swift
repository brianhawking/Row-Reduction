////
////  IAPService.swift
////  System of Equations
////
////  Created by Brian Veitch on 1/1/20.
////  Copyright © 2020 Brian Veitch. All rights reserved.
////
//
//import Foundation
//import StoreKit
//import SwiftKeychainWrapper
//
//class IAPService: NSObject {
//    
//    private override init() {}
//    static let shared = IAPService()
//    
//    var products = [SKProduct]()
//    var purchasedProducts = [SKProduct]()
//    
//    let paymentQueue = SKPaymentQueue.default()
//    
//    func getProducts() {
//        let products: Set = [IAPProduct.instantSolution.rawValue]
//        print("Here are my products, \(products)")
//        
//        // get purchased products
//        purchasedProducts = products.filter{
//            KeychainWrapper.standard.bool(forKey: $0) ?? false}
//        
//        
//        
//        let request = SKProductsRequest(productIdentifiers: products)
//        request.delegate = self
//        request.start()
//        paymentQueue.add(self)
//    }
//    
//    func purchase(product: IAPProduct) {
//       
//        print("The product IDS in IAPService are \(products). The product in app is \(product)")
//        guard let productToPurchase = products.filter({$0.productIdentifier == product.rawValue}).first
//            else {
//                print("Can't find \(product)")
//                return
//            }
//        let payment = SKPayment(product: productToPurchase)
//        paymentQueue.add(payment)
//    }
//    
//    func restorePurchases() {
//        print("Restoring purchases")
//        paymentQueue.restoreCompletedTransactions()
//    }
//}
//
//extension IAPService: SKProductsRequestDelegate {
//    
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        print(response.products)
//        self.products = response.products
//        for product in response.products {
//            print(product.productIdentifier)
//        }
//    }
//}
//
//extension IAPService: SKPaymentTransactionObserver {
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//            print("The transaction status is ",transaction.transactionState.status(), transaction.payment.productIdentifier)
//            switch transaction.transactionState {
//            case .purchasing: break
//            default: queue.finishTransaction(transaction)
//            }
//        }
//    }
//}
//
//extension SKPaymentTransactionState {
//    func status() -> String {
//        switch self {
//        case .deferred: return "Deferred"
//        case .failed: return "Failed"
//        case .purchased: return "Purchased"
//        case .purchasing: return "Purchasing"
//        case .restored: return "Restored"
//        default:
//            return "Error"
//        }
//    }
//}
