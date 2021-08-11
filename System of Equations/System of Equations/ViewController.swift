//
//  ViewController.swift
//  System of Equations
//
//  Created by Brian Veitch on 12/4/19.
//  Copyright © 2019 Brian Veitch. All rights reserved.
//

import UIKit
import CoreGraphics


class ViewController: UIViewController {

    @IBOutlet var screenView: UIView!
  

    // current position of box
    var currentRow: Int = 0
    var currentCol: Int = 0
    
    // initial srt up with 2 equations 2 variables
    var numberOfEquations: Int = 2
    var numberOfVariables: Int = 2
    
    // this is used to check if the previous input was '/'.  will probably delete
    var previousRow: Int = -1
    var previousCol: Int = -1
    
    // setup
    @IBOutlet weak var equationsStackview: UIStackView!
    
    // add coefficients
    @IBOutlet var row1Coefficients: [UILabel]!
    @IBOutlet var row2Coefficients: [UILabel]!
    @IBOutlet var row3Coefficients: [UILabel]!
    @IBOutlet var row4Coefficients: [UILabel]!
    // fontsize
    var pointSize: CGFloat = 36

    
    // add the plus signs
    @IBOutlet var row1Plus: [UILabel]!
    @IBOutlet var row2Plus: [UILabel]!
    @IBOutlet var row3Plus: [UILabel]!
    @IBOutlet var row4Plus: [UILabel]!
    
    // add the variable names
    @IBOutlet var row1Variables: [UILabel]!
    @IBOutlet var row2Variables: [UILabel]!
    @IBOutlet var row3Variables: [UILabel]!
    @IBOutlet var row4Variables: [UILabel]!
    
    // matrix will contain row variables
    var variableMatrix: [[UILabel]] = []
    
    
    // add equals
    @IBOutlet var equalsMatrix: [UILabel]!
    var plusMatrix: [[UILabel]] = []
    
    // set up augmented matrix button
    @IBOutlet weak var setupButton: UIButton!
    
    // numberpad stackview.  Added so user can swipe on it
    @IBOutlet weak var numberPadView: UIStackView!
    
    // stores location, and string versions of coefficients
    var matrixOfStrings: [[UILabel]] = []
    
    // this will be the matrix of strings but I add the number of rows and columns
    var preparedMatrix: [[String]] = []
    
    // indiviual numberpad buttons
    @IBOutlet var numberpadButtons: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        adjustSizes()
        
        // set up numberpad buttons
        for button in numberpadButtons {
            button.layer.cornerRadius = 10
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
        }
        
        // add the swipe gestures
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        screenView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        screenView.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        screenView.addGestureRecognizer(swipeDown)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGesture))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        screenView.addGestureRecognizer(swipeUp)
        
        
        // add all the coefficients into the matrix of strings
        matrixOfStrings.append(row1Coefficients)
        matrixOfStrings.append(row2Coefficients)
        matrixOfStrings.append(row3Coefficients)
        matrixOfStrings.append(row4Coefficients)
        
        plusMatrix.append(row1Plus)
        plusMatrix.append(row2Plus)
        plusMatrix.append(row3Plus)
        plusMatrix.append(row4Plus)
        
        variableMatrix.append(row1Variables)
        variableMatrix.append(row2Variables)
        variableMatrix.append(row3Variables)
        variableMatrix.append(row4Variables)
        
        for row in matrixOfStrings {
            for col in row {
                pointSize = col.font.pointSize
                col.isHidden = true
                col.adjustsFontSizeToFitWidth = true
                //col.font = UIFont.boldSystemFont(ofSize: 24)
                col.text = "0"
            }
        }
        
        hideEverything()
        
        updateMatrix()
 
        
        matrixOfStrings[currentRow][currentCol].blink()

    }
    
    func adjustSizes() {
        equationsStackview.translatesAutoresizingMaskIntoConstraints = false
        
        equationsStackview.heightAnchor.constraint(equalTo: screenView.heightAnchor, multiplier: 0.3).isActive = true
    }
    
    func hideEverything() {
        
        // add a default value of 0 to the coefficients
        // make them initially invisible
        for row in matrixOfStrings {
            for col in row {
                col.isHidden = true
            }
        }
         
        for row in plusMatrix {
            for col in row {
                col.isHidden = true
            }
        }
         
        for row in variableMatrix {
            for col in row {
                col.isHidden = true
            }
        }
         
        for equals in equalsMatrix {
            equals.isHidden = true
        }
    }
    
    func showWhatsAllowed() {
        // show all the buttons, and labels that are allowed
        for i in 0..<numberOfEquations {
            for j in 0..<numberOfVariables {
                matrixOfStrings[i][j].isHidden = false
            }
            matrixOfStrings[i][4].isHidden = false
        }

        for i in 0..<numberOfEquations {
            for j in 0..<numberOfVariables-1 {
                plusMatrix[i][j].isHidden = false
            }
        }

        for i in 0..<numberOfEquations {
            for j in 0..<numberOfVariables {
                variableMatrix[i][j].isHidden = false
            }
        }

        for i in 0..<numberOfEquations {
            equalsMatrix[i].isHidden = false
        }
    }
    
    
    @objc func swipeGesture (sender: UISwipeGestureRecognizer?) {
        
        if(matrixOfStrings[currentRow][currentCol].text! == ""){
            return
        }
        
        // check if they're divinding by 0
        let ND = matrixOfStrings[currentRow][currentCol].text!.components(separatedBy: "/")
        if ND.count == 2 {
            if ND[1] == "0" {
                return
            }
        }
        
        
        previousRow = currentRow
        previousCol = currentCol
        matrixOfStrings[currentRow][currentCol].stopBlink()
        
        
        if sender != nil {
            //print(sender!.direction)
            switch sender!.direction {
            case UISwipeGestureRecognizer.Direction.up: // up
                    if(currentRow > 0) {
                        currentRow -= 1
                    }
                case UISwipeGestureRecognizer.Direction.right: // right
                    if(currentCol < numberOfVariables-1){
                        currentCol += 1
                    }
                    else if(currentCol == numberOfVariables-1){
                        currentCol = 4
                        
                    }
                    else if (currentCol == 4 && currentRow != numberOfEquations-1){
                        currentCol = 0
                        currentRow += 1
                    }
    
                case UISwipeGestureRecognizer.Direction.down: // down
                    if(currentRow < numberOfEquations-1){
                        currentRow += 1
                    }
                case UISwipeGestureRecognizer.Direction.left: // left
                    if(currentCol == 4){
                        currentCol = numberOfVariables-1
                    }
                    else if(currentCol > 0){
                        currentCol -= 1
                    }
                    
                default:
                    break
                
            }
        }
        
        matrixOfStrings[currentRow][currentCol].blink()
    }
    
    func updateMatrix() -> Void {
  
        // hide everything
        hideEverything()
        
        
        // show what's allowed
        showWhatsAllowed()

    }
    
    
    @IBAction func adjustMatrixSize(_ sender: UIButton) {
       // adjust the matrix if user adds or removes variables or equations
        switch sender.tag {
        case 15: // add variable
            if(numberOfVariables != 4){
                numberOfVariables += 1
            }
        case 16: // remove variable
            if(numberOfVariables > 2){
                numberOfVariables -= 1
                
            }
            
        case 17: // add equation
            if(numberOfEquations != 4){
                numberOfEquations += 1
            }
            
        case 18: // remove equation
           if(numberOfEquations > 2) {
                numberOfEquations -= 1
            }
        default:
            break
        }
        
        updateMatrix()
    }
    
    
    
    
    
    @IBAction func enterNumbers(_ sender: UIButton) {
        if(previousRow != currentRow || previousCol != currentCol){
            matrixOfStrings[currentRow][currentCol].text = ""
            previousRow = currentRow
            previousCol = currentCol
        }
       
        
        switch sender.tag {
        case 1...10:
            if(matrixOfStrings[currentRow][currentCol].text! != "-0"){
                matrixOfStrings[currentRow][currentCol].text! += String(sender.tag-1)
            }
            else {
                matrixOfStrings[currentRow][currentCol].text! = "-"+String(sender.tag-1)
            }
            
        
        case 12:  // how do deal with the negative sign
            if(matrixOfStrings[currentRow][currentCol].text! == ""){
                matrixOfStrings[currentRow][currentCol].text! = "-0"
            }
            
            else if(!matrixOfStrings[currentRow][currentCol].text!.contains("-")){
                matrixOfStrings[currentRow][currentCol].text!.insert("-", at: matrixOfStrings[currentRow][currentCol].text!.startIndex)
            }
            else {
                matrixOfStrings[currentRow][currentCol].text!.remove(at: matrixOfStrings[currentRow][currentCol].text!.startIndex)
            }
        
        case 14: // presses the delete button
            switch matrixOfStrings[currentRow][currentCol].text!.count {
            case 0:
                return
            case 1:
                matrixOfStrings[currentRow][currentCol].text!.removeLast()
                return
            default:
                matrixOfStrings[currentRow][currentCol].text!.removeLast()
            }
          
        case 20: // selects the decimal
            if (matrixOfStrings[currentRow][currentCol].text!.contains("/")){
                return
            }
            if (!matrixOfStrings[currentRow][currentCol].text!.contains(".")){
                matrixOfStrings[currentRow][currentCol].text! += "."
            }
            if(matrixOfStrings[currentRow][currentCol].text! == "."){
                matrixOfStrings[currentRow][currentCol].text! = "0."
            }
            
        case 21: // add the fraction
           
            if(matrixOfStrings[currentRow][currentCol].text!.contains("/") || matrixOfStrings[currentRow][currentCol].text!.contains(".")){
                return
            }
            
            if(matrixOfStrings[currentRow][currentCol].text! != ""){
                matrixOfStrings[currentRow][currentCol].text! += "/"

                //return
            }
            
            
        default:
            break
        }
        
        displayFraction(label: matrixOfStrings[currentRow][currentCol], text: matrixOfStrings[currentRow][currentCol].text!)
        
    }
    
    
    @IBAction func prepareData(_ sender: Any) {
       
       
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        var counter: Int = 0
        
        if(segue.identifier == "MatrixController") {
            preparedMatrix.removeAll()
                var temp: [String] = []
                for row in matrixOfStrings {
                    for col in row {
                        temp.append(col.text!)
                        //temp.append("\(counter)")
                        counter += 1
                        
                    }

                    preparedMatrix.append(temp)
                    temp = []
                }
                preparedMatrix.append([String(numberOfEquations),String(numberOfVariables)])
                
            
                
                let vc = segue.destination as! MatrixController
                vc.matrixOfStrings = preparedMatrix
        }
        
        
    }
    
    func displayFraction(label: UILabel, text: String) {
        
       // let pointSize : CGFloat = 30
        
        let systemFontDesc = UIFont.systemFont(ofSize: pointSize,
                                               weight: UIFont.Weight.medium).fontDescriptor
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
//        if(ND[1] == "1"){
//            label.font = UIFont (name: "Futura", size: 26)
//            label.text! = ND[0]
//        }
        else {
            label.font = UIFont(descriptor: fractionFontDesc, size:pointSize+10)
            label.text! = text // note just plain numbers and a regular sl
        }
        
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.2
        
    }
    
}


extension UILabel {
    
    func blink() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
//        self.alpha = 0.0;
//        UIView.animate(withDuration: 0.8, //Time duration you want,
//            delay: 0.0,
//            options: [.curveEaseInOut, .autoreverse, .repeat],
//            animations: { [weak self] in self?.alpha = 1.0 },
//            completion: { [weak self] _ in self?.alpha = 0.0 })
    }
}

extension UILabel {
    func stopBlink() {
        self.layer.borderWidth = 0
        self.alpha = 1;
        
    }
}

