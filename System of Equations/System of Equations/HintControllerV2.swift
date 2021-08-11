//
//  HintController.swift
//  System of Equations
//
//  Created by Brian Veitch on 12/12/19.
//  Copyright © 2019 Brian Veitch. All rights reserved.
//

import UIKit

class HintControllerV2: UIViewController {

    var delegate: hintDelegate?
    
    var matrix: Matrix = Matrix(rows: 4, columns: 5)
    
    var rows: Int = 2
    var columns: Int = 2
    
    var pivotColumn = 0
    var pivotRow = 0
    
    var matrixComplete: Bool = false
    var solution: [Fraction] = []
    
    var foundLeadingOne: Bool = false
    var leadingOneRow: [Int] = []
    
    var foundNonZero: Bool = false
    var nonZeroRow: [Int] = []
    
    var rowString: String = ""
    @IBOutlet weak var hintText: UILabel!
    
    var hints: [Bool] = [true, false, false]
    
    @IBOutlet weak var mainView: CommonButton!
    @IBOutlet weak var changeRow: UIImageView!
    @IBOutlet weak var pivotRowImage: UIImageView!
    @IBOutlet weak var reciprocal: UILabel!
    @IBOutlet weak var newRow: UIImageView!
    
    @IBOutlet weak var plus: UILabel!
   // @IBOutlet weak var arrow: UIButton!
    @IBOutlet weak var arrow: UIImageView!
    
    @IBOutlet weak var operationHint: UIStackView!
    
    // font size
    var pointSize: CGFloat = 26
    @IBOutlet weak var textForPointSize: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        adjustSizes()
        
        pointSize = textForPointSize.font.pointSize
        
        hintText.text = ""
        changeRow.isHidden = true
        reciprocal.isHidden = true
        pivotRowImage.isHidden = true
        newRow.isHidden = true
        
        plus.isHidden = true
        arrow.isHidden = true
        
        if(pivotColumn >= columns){
            matrixComplete = true
        }
        
        if(pivotRow >= rows){
            matrixComplete = true
        }
        
        if(matrixComplete == true){
            // read across
            
            
            readAnswerV3()
            //readAnswer()
            
            
//            for i in 0..<rows {
//                solution.append(matrix.grid[i][4])
//            }
//            hintText.text! = "Solution is ("
//            for e in solution {
//                let text = "\(e.num)/\(e.den)"
//                displayFractionText(text: text)
//                hintText.text! += ", "
//            }
//            hintText.text!.removeLast()
//            hintText.text!.removeLast()
//            hintText.text! += ")"
            
        }
        else {
            // search pivot column for leading one
            searchForLeadingOne()
        }
        
        
        
    }
    
    func readAnswerV3() {
        
        hintText.text! = ""
        var rowResult: [String] = ["", "", "", ""]
        let parameters: [String] = ["u", "t", "s", "v"]
        var start: Bool = false
        var infinintelyManySolutions: Bool = false
        var noSolution: Int = -1
        let ONE: Fraction = Fraction(num: 1, den: 1)
        let ZERO: Fraction = Fraction(num: 0, den: 1)
        var currentVariable: Int = 0
        var infText: String = ""
        
        
        
        // 1 0 0 -2     1 -2 0 3    1  2  0  3
        // 0 1 0 2      0  0 1 3    0  0  1  3
        // 0 0 1 3      0  0 0 0    0  0  0  0
        
        // 1 0 2/3
        // 0 1 4
        // 0 0 0
        
        for i in 0..<rows {
            
            // read across
            for j in 0..<columns {
                
                
                if(start == true && matrix.grid[i][j].num < 0 && matrix.grid[i][4] != ZERO){
                    rowResult[currentVariable] += "+\(matrix.grid[i][j].negateForText())\(parameters[j])"
                 }
                else if(start == true && matrix.grid[i][j].num < 0 && matrix.grid[i][4] == ZERO){
                   rowResult[currentVariable] += "\(matrix.grid[i][j].negateForText())\(parameters[j])"
                }
                else if(start == true && matrix.grid[i][j].num > 0){
                    rowResult[currentVariable] += "-\(matrix.grid[i][j].fraction())\(parameters[j])"
                }
                
                
                if matrix.grid[i][j] == ONE && start == false {
                    // this is the start of the row
                    start = true
                    currentVariable = j
                    if(matrix.grid[i][4] != ZERO) {
                       rowResult[currentVariable] += matrix.grid[i][4].fraction()
                    }
                    
                }
                
                
            }
            
            if(start == true && rowResult[currentVariable] == ""){
                rowResult[currentVariable] = matrix.grid[i][4].fraction()
            }
           
            
            if(start == false){
                // this column did not have any leading ones.
                // check if it's no solution
                if (matrix.grid[i][4] != ZERO){
                    print("No solution.")
                    noSolution = i
                    break
                }
            }
            
            
            start = false
            
        }
        for i in 0..<columns {
            if rowResult[i] == "" {
                rowResult[i] = parameters[i]
                infText += "x\(i+1) has no leading 1.  This means it can be any real number.  Let x\(i+1) = \(parameters[i]).\n"
                infinintelyManySolutions = true
            }
        }
        
        if(noSolution != -1){
            hintText.text! = "This system has no solution.  If you translate Row \(noSolution+1) you get \n\n "
            for j in 0..<columns {
                hintText.text! += "0 x\(j+1) + "
            }
            hintText.text!.removeLast()
            hintText.text!.removeLast()
            hintText.text! += "= \(matrix.grid[noSolution][4].fraction())\n\nThere are no values that make this equation true."
            return
        }
        
        else if (infinintelyManySolutions == true){
            hintText.text! = "There are infinitely many solutions.\n"
            hintText.text! += infText + "\nThe solution is...\n\n"
        }
        else {
            hintText.text! = "You have a unique solution.  It is...\n\n"
        }
        
        hintText.text! += "("
        for i in 0..<columns {
            
            hintText.text! += rowResult[i] + ", "
        }
        hintText.text!.removeLast()
        hintText.text!.removeLast()
        hintText.text! += ")"
        print(rowResult)
        
    }
    
    
    func checkIfNoSolution(row: Int) {
        var  numberOfZeros: Int = 0
        for col in 0..<columns {
            if(matrix.grid[row][col] == Fraction(num: 0, den: 0)){
                numberOfZeros += 1
            }
        }
        
        if(numberOfZeros == rows && matrix.grid[row][4] == Fraction(num: 0, den: 0)){
            // infintely many solutions
        }
        else if (numberOfZeros == rows && !(matrix.grid[row][4] == Fraction(num: 0, den: 0) )){
            // no solution
            hintText.text! += "You have a row of zeros ending with a non zero in Row \(row+1).  This means you have no solution."
        }
            
    }
    
    func adjustSizes() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
              mainView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        operationHint.translatesAutoresizingMaskIntoConstraints = false
        operationHint.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        
        reciprocal.translatesAutoresizingMaskIntoConstraints = false
        reciprocal.widthAnchor.constraint(equalTo: operationHint.widthAnchor, multiplier: 0.3).isActive = true
    }
    
    func rowPlusRow () {
        
    
        
       // we have a leading one in the correct row
        for i in 0..<rows {
            
            if(matrix.grid[i][pivotColumn].num != 0 && i != pivotRow){
                changeRow.isHidden = false
                reciprocal.isHidden = false
                pivotRowImage.isHidden = false
                newRow.isHidden = false
                plus.isHidden = false
                arrow.isHidden = false
                // row operate
                hintText.text! += "Evaluate the following row operation.\n"
                
                changeRow.image = UIImage(named: "R\(i+1)")
                
                displayFractionNew(label: reciprocal, text: "\(-1*matrix.grid[i][pivotColumn])")
                pivotRowImage.image = UIImage(named: "R\(pivotRow+1)")
                newRow.image = UIImage(named: "R\(i+1)")
                
                
                return
            }
        
        }
        changeRow.isHidden = true
        reciprocal.isHidden = true
        pivotRowImage.isHidden = true
        newRow.isHidden = true
        plus.isHidden = true
        arrow.isHidden = true
        hintText.text! += "You're all good with this pivot element."
        pivotRow += 1
        pivotColumn += 1
    }
    
    func multiplyByConstant() {
        
        if (hints[2] == true){
            rowPlusRow()
            return
        }
        // is there a leading one?
        if(matrix.grid[pivotRow][pivotColumn] == Fraction(num: 1, den: 1)){
            hints = [false, false, true]
            rowPlusRow()
            return
        }
        else {
            // multiply by a constant
            var numerator = matrix.grid[pivotRow][pivotColumn].num
            var denominator = matrix.grid[pivotRow][pivotColumn].den
            
            if(numerator < 0){
                numerator = numerator * -1
                denominator = denominator * -1
            }
          //  let constant = Fraction(num: denominator, den: numerator)
            
           // hintText.text! += "Multiply Row \(pivotRow+1) by \(constant.num)/\(constant.den)."
            hintText.text! += "Multiply Row \(pivotRow+1) by \( matrix.grid[pivotRow][pivotColumn].reciprocal() )."
            
            
            reciprocal.isHidden = false
            pivotRowImage.isHidden = false
            newRow.isHidden = false
            arrow.isHidden = false
            
            displayFractionNew(label: reciprocal, text: "\(matrix.grid[pivotRow][pivotColumn].reciprocal())")
            pivotRowImage.image = UIImage(named: "R\(pivotRow+1)")
            newRow.image = UIImage(named: "R\(pivotRow+1)")
            
            
        }
    }
    
    func searchForLeadingOne() {
         
        print(pivotRow, pivotColumn)
        var numberOfZeros: Int = 0
        
        for i in 0..<rows {
            if(matrix.grid[i][pivotColumn] == Fraction(num: 1, den: 1) && i >= pivotRow){
               foundLeadingOne = true
                leadingOneRow.append(i)

            }
            else if(matrix.grid[i][pivotColumn].num != 0 && i >= pivotRow){
                foundNonZero = true
                nonZeroRow.append(i)

            }
            else if (matrix.grid[i][pivotColumn].num == 0){
                numberOfZeros += 1
            }

        }
        
        
        if(hints == [false, false, true]) {
            // go to 3rd operation
            rowPlusRow()
            return
        }
        if(hints == [false, true, false]) {
            // go to 2rd operation
            multiplyByConstant()
            return
        }
        
        
        
        if(foundLeadingOne == true){
            
            if(leadingOneRow.count > 0){
                // leading one was found
                
                if(leadingOneRow.contains(pivotRow)){
                    
                    hintText.text! += "A leading 1 was found in the pivot location: row \(pivotRow+1), column \(pivotColumn+1).\n\n"
                    if(numberOfZeros == rows - 1){
                        hintText.text! += "Your column is complete.  You will be moved to the next pivot element.\n"
                    }
                    else {
                        hintText.text! += "Use the third row operation to make the rest of the numbers in the column 0s.\n"
                    }
                    
                    hints = [false, false, true]
                    return
                   }
                
                else {
                    hintText.text! += "A 1 was found in the pivot column: column \(pivotColumn+1) but it's not in the pivot row: row \(pivotRow+1).\n"
                    hintText.text! += "Consier swapping row \(pivotRow+1) with row \(leadingOneRow[0]+1)\n"
                    
                }
            }
        
        }

        else if(foundNonZero == true){
            hintText.text! += "No leading 1 was found in column \(pivotColumn+1). But a nonzero was found in row \(nonZeroRow[0]+1).\n"
            if(pivotRow == nonZeroRow[0]){
                hintText.text! += "Scale row \(pivotRow+1) to have a leading one.\n"
                hints = [false, true, false]
            }
            else {
                hintText.text! += "Swap row \(pivotRow+1) with row \(nonZeroRow[0]+1). Then scale the row to have a leading one.\n"
            }
            
        }

        else {
            hintText.text! += "No leading 1 or non zero was found in an eligible row in the pivot column.  Move your pivot column to the right.  You can do this multiplying the current Pivot Row, Row \(pivotRow+1) by 1.\n"
            
        }
        
        
    }
    
    func displayFractionNew(label: UILabel, text: String) {
        // displayFraction(label: matrixOfButtons[currentRow][currentCol])
        let pointSize : CGFloat = 36
        let systemFontDesc = UIFont.systemFont(ofSize: pointSize,
                                               weight: UIFont.Weight.regular).fontDescriptor
        let fractionFontDesc = systemFontDesc.addingAttributes(
            [
                UIFontDescriptor.AttributeName.featureSettings: [
                    [
                        UIFontDescriptor.FeatureKey.featureIdentifier: kFractionsType,
                        UIFontDescriptor.FeatureKey.typeIdentifier: kDiagonalFractionsSelector,
                        ],
                ]
            ] )

        //let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        let ND = text.components(separatedBy: "/")
        if(ND[1] == "1"){
            label.font = UIFont (name: "Futura", size: pointSize)
            label.text! = ND[0]
        }
        else {
            label.font = UIFont(descriptor: fractionFontDesc, size:pointSize+10)
            label.text! = text // note just plain numbers and a regular sl
        }
        
    }
    
    func displayFractionText(label: UILabel, text: String) {
         
           let systemFontDesc = UIFont.systemFont(ofSize: pointSize,
                                                  weight: UIFont.Weight.regular).fontDescriptor
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
           if(ND[1] == "1"){
               label.font = UIFont (name: "Futura", size: pointSize)
               label.text! += ND[0]
           }
           else {
               label.font = UIFont(descriptor: fractionFontDesc, size:pointSize+10)
               label.text! +=  text // note just plain numbers and a regular sl
           }
           
           
           
       }
    


    @IBAction func dismissHintController(_ sender: Any) {
        dismiss(animated: true) {
            self.delegate?.getHint(hints: self.hints, pivotRow: self.pivotRow, pivotColumn: self.pivotColumn)
                 
        }
    }
}

protocol hintDelegate {
    func getHint(hints: [Bool], pivotRow: Int, pivotColumn: Int)
}
