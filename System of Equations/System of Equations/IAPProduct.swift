//
//  IAPProduct.swift
//  System of Equations
//
//  Created by Brian Veitch on 1/1/20.
//  Copyright © 2020 Brian Veitch. All rights reserved.
//

import Foundation

public struct IAPProducts {
  
  public static let instantSolution = "com.brianveitch.instantSolution"
  
    private static let productIdentifiers: Set<ProductIdentifier> = [IAPProducts.instantSolution]

  public static let store = IAPHelper(productIds: IAPProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}
