//
//  RowPlusConstantRowController.swift
//  System of Equations
//
//  Created by Brian Veitch on 12/10/19.
//  Copyright © 2019 Brian Veitch. All rights reserved.
//

import UIKit

class RowPlusConstantRowController: UIViewController {

    var delegate: RowPlusConstantRowDelegate?
    var firstTime: Bool = true
    
    var constant: Fraction = Fraction(num: 1, den: 1)
    var whichRows: [Int] = [1,2]
    var numberOfEquations: Int = 2
    
    // row buttons
    @IBOutlet var rowButtons: [UIButton]!
    
    @IBOutlet weak var changedRow: UIImageView!
    @IBOutlet weak var pivotRow: UIImageView!
    @IBOutlet weak var newRow: UIImageView!
    
    @IBOutlet weak var constantLabel: UILabel!
    @IBOutlet weak var numberPadView: UIStackView!
    @IBOutlet weak var StackViewPopUp: UIStackView!
    @IBOutlet weak var mainView: CommonButton!
    
  //  @IBOutlet weak var mainView: CommonButton!
    // row operation to determine who to box and change
    var rowOperation: Int = 25
    
    @IBOutlet weak var textForPointSize: UILabel!
    var pointSize: CGFloat = 36
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changedRow.layer.borderWidth = 1
        
        pointSize = textForPointSize.font.pointSize
        
        for button in rowButtons {
            
            
            if(button.tag > numberOfEquations){
                button.isHidden = true
            }
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        StackViewPopUp.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        StackViewPopUp.addGestureRecognizer(swipeLeft)
        
        adjustSizes()

    }
    
    func adjustSizes() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6).isActive = true
    }
    
    @objc func swipeGesture (sender: UISwipeGestureRecognizer?) {
        
        changedRow.layer.borderWidth = 0
        constantLabel.layer.borderWidth = 0
        pivotRow.layer.borderWidth = 0
        
        if sender != nil {
            //print(sender!.direction)
            switch sender!.direction {
            
            case UISwipeGestureRecognizer.Direction.right: // right
                if(rowOperation != 27){
                   rowOperation += 1
                }
                
               
            case UISwipeGestureRecognizer.Direction.left:
                // left
                if (rowOperation != 25){
                   rowOperation -= 1
                }
                
                    
            default:
                break
                
            }
        }
        
        switch rowOperation {
        case 25:
            changedRow.layer.borderWidth = 1
        
        case 26:
            constantLabel.layer.borderWidth = 1
        case 27:
            pivotRow.layer.borderWidth = 1
        default:
            break
        }
        
    }
    
    func convertToFraction() {


        if(constantLabel.text! == ""){
            constantLabel.text! = "1"
        }
        
        var numerator: Int = 1
        var denominator: Int = 1

        if(constantLabel.text!.contains("/")){
            // find num, den
            let ND = constantLabel.text!.components(separatedBy: "/")

            numerator = Int(ND[0])!
            denominator = Int(ND[1])!


        }
        else {
            numerator = Int(constantLabel.text!)!
        }

        constant.update(numerator, denominator)

    }
    
    @IBAction func enterNumbers(_ sender: UIButton) {
           
        if firstTime == true {
               constantLabel.text! = ""
               firstTime = false
        }
        
        switch sender.tag {
           case 1...10:
               constantLabel.text! += String(sender.tag-1)
               
           case 12:
           
               if(constantLabel.text!.contains("-")){
                   constantLabel.text!.removeFirst()
               }
               else {
                   constantLabel.text!.insert("-", at: constantLabel.text!.startIndex)
               }
               
           case 18:
              if (constantLabel.text!.count > 0){
                constantLabel.text!.removeLast()
              }
               
               
           case 21:
            if(constantLabel.text!.count == 0){
                return
            }
               if(!constantLabel.text!.contains("/")){
                   // doesn't have fraction bar
                   constantLabel.text! += "/"
               }
               
           default:
               break
           }
        
        displayFraction(label: constantLabel, text: constantLabel.text!)
        
    }

      func displayFraction(label: UILabel, text: String) {
          
      //    let pointSize : CGFloat = 52
          let systemFontDesc = UIFont.systemFont(ofSize: pointSize,
                                                 weight: UIFont.Weight.light).fontDescriptor
          let fractionFontDesc = systemFontDesc.addingAttributes(
              [
                  UIFontDescriptor.AttributeName.featureSettings: [
                      [
                          UIFontDescriptor.FeatureKey.featureIdentifier: kFractionsType,
                          UIFontDescriptor.FeatureKey.typeIdentifier: kDiagonalFractionsSelector,
                          ],
                  ]
              ] )
          
          let ND = text.components(separatedBy: "/")
          if(ND.count == 1){
              label.font = UIFont (name: "Futura", size: pointSize)
              return
          }
//          if(ND[1] == "1"){
//              label.font = UIFont (name: "Futura", size: 56)
//              label.text! = ND[0]
//          }
          else {
              label.font = UIFont(descriptor: fractionFontDesc, size:pointSize+10)
              label.text! = text // note just plain numbers and a regular sl
          }
          
      }
    
    @IBAction func chooseRow(_ sender: UIButton) {
        
        switch rowOperation {
        case 25:
            whichRows[0] = sender.tag
            changedRow.image = UIImage(named: "R\(sender.tag)")
            newRow.image = UIImage(named: "R\(sender.tag)")
        case 27:
            whichRows[1] = sender.tag
            pivotRow.image = UIImage(named: "R\(sender.tag)")
        default:
            break
        }
        
       // print(whichRows)
        
    }
    
    
    @IBAction func cancelAxtion(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func dismissController(_ sender: Any) {
        
        convertToFraction()
        
        if(constantLabel.text! == "" || constant.den == 0){
            return
        }
        else {
            if(whichRows[0] != whichRows[1]){
                dismiss(animated: true) {
                    
                    self.delegate?.getInfo(rows: self.whichRows, constant: self.constant)
                }
            }
        }
        
    }
    
}

protocol RowPlusConstantRowDelegate {
    func getInfo(rows: [Int], constant: Fraction)
}
