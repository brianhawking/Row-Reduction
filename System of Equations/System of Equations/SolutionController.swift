//
//  SolutionController.swift
//  System of Equations
//
//  Created by Brian Veitch on 12/15/19.
//  Copyright © 2019 Brian Veitch. All rights reserved.
//

struct solutionMatrices {
    
}

import UIKit

class SolutionController: UIViewController {

    
    @IBOutlet weak var mainStackView: UIStackView!
    
    var rref: Matrix = Matrix(rows: 4, columns: 5)
    
    var rowOperation: String = ""
    
    var pointSize: CGFloat = 27
    
    var matrix: Matrix = Matrix(rows: 4, columns: 5)
    var matrixComplete: Bool = false
    var allMatrixPositions: [Matrix] = []
    var m: Int = 0
    
    var rows: Int = 2
    var columns: Int = 2
    
    var pivotRow: Int = 0
    var pivotColumn: Int = 0
    
    var foundLeadingOne: Bool = false
    var leadingOneRow: [Int] = []
    var foundNonZero: Bool = false
    var nonZeroRow: [Int] = []
    
    
    @IBOutlet weak var rowReductionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pointSize = rowReductionLabel.font.pointSize
        
        
        allMatrixPositions.append(matrix)
        
        addStackView()
        
        startRowReducing()
        
    }
    
    func addSpace() {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.spacing = 10
        rowStackView.distribution = .fillEqually
        
        let line = UIView()
        line.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 1)
        line.backgroundColor = .black
        
        let label = UILabel()
        label.text = "------------------------------------"
        
       
        //rowStackView.addArrangedSubview(label)
        rowStackView.addSubview(line)
        
        mainStackView.addArrangedSubview(rowStackView)
    }
    
    func addRowPlusRow(reciprocal: Fraction, changed: Int, Pivot: Int) {
        let operationStackView = UIStackView()
        operationStackView.axis = .horizontal
        operationStackView.spacing = 4
        operationStackView.distribution = .fillProportionally
        operationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        var imageName = "R\(changed+1)"
        var image = UIImage(named: imageName)
        let changedRow = UIImageView(image: image!)
        operationStackView.addArrangedSubview(changedRow)
        changedRow.contentMode = .scaleAspectFit
        //changedRow.clipsToBounds = true
       
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: pointSize)
        
        label.text = reciprocal.fraction()
        displayFraction(label: label, text: label.text!)
        label.frame = CGRect()
        operationStackView.addArrangedSubview(label)
        label.contentMode = .scaleAspectFit
       // label.clipsToBounds = true
        
        imageName = "R\(Pivot+1)"
        image = UIImage(named: imageName)
        let pivotRow1 = UIImageView(image: image!)
        operationStackView.addArrangedSubview(pivotRow1)
        pivotRow1.contentMode = .scaleAspectFit
      //  pivotRow1.clipsToBounds = true

        imageName = "rightarrow"
        image = UIImage(named: imageName)
        let arrow = UIImageView(image: image)
        operationStackView.addArrangedSubview(arrow)
        arrow.contentMode = .scaleAspectFit
      //  arrow.clipsToBounds = true
       

        imageName = "R\(changed+1)"
        image = UIImage(named: imageName)
        let newRow = UIImageView(image: image!)
        operationStackView.addArrangedSubview(newRow)
        newRow.contentMode = .scaleAspectFit
      //  newRow.clipsToBounds = true
        

        mainStackView.addArrangedSubview(operationStackView)
        operationStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.85).isActive = true
               
        addSpace()
    }
    
    func addScaleView(reciprocal: Fraction, row: Int) {
        let operationStackView = UIStackView()
        operationStackView.axis = .horizontal
        operationStackView.spacing = 5
        operationStackView.distribution = .fillProportionally
        operationStackView.translatesAutoresizingMaskIntoConstraints = false
        
       
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: pointSize)
        
        label.text = reciprocal.fraction()
        displayFraction(label: label, text: label.text!)
        label.frame = CGRect()
        operationStackView.addArrangedSubview(label)
        label.contentMode = .scaleAspectFit
        
        
        var imageName = "R\(row+1)"
        var image = UIImage(named: imageName)
        let changedRow = UIImageView(image: image!)
        operationStackView.addArrangedSubview(changedRow)
        changedRow.contentMode = .scaleAspectFit
        
        imageName = "rightarrow"
        image = UIImage(named: imageName)
        let arrow = UIImageView(image: image)
        operationStackView.addArrangedSubview(arrow)
        arrow.contentMode = .scaleAspectFit
        
        imageName = "R\(row+1)"
        image = UIImage(named: imageName)
        let newRow = UIImageView(image: image)
        operationStackView.addArrangedSubview(newRow)
        newRow.contentMode = .scaleAspectFit
        
        
        operationStackView.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        
        mainStackView.addArrangedSubview(operationStackView)
        operationStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.75).isActive = true
               
        addSpace()
    }
    
    func addSwapRows(lhs: Int, rhs: Int) {
        let operationStackView = UIStackView()
        operationStackView.axis = .horizontal
        operationStackView.spacing = 5
        operationStackView.distribution = .fillProportionally
        
        operationStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        var imageName = "R\(lhs+1)"
        var image = UIImage(named: imageName)
        let leftSide = UIImageView(image: image!)
        operationStackView.addArrangedSubview(leftSide)
        
        leftSide.contentMode = .scaleAspectFit
        
        imageName = "leftrightarrow"
        image = UIImage(named: imageName)
        let arrow = UIImageView(image: image)
        operationStackView.addArrangedSubview(arrow)
        arrow.contentMode = .scaleAspectFit
        
        imageName = "R\(rhs+1)"
        image = UIImage(named: imageName)
        let rightSide = UIImageView(image: image)
        operationStackView.addArrangedSubview(rightSide)
        rightSide.contentMode = .scaleAspectFit
        
         operationStackView.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        
        mainStackView.addArrangedSubview(operationStackView)
        operationStackView.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: 0.65).isActive = true
       
               
        addSpace()
    }
    
    func addStackView() {
        
     
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 10
        stackview.distribution = .fillEqually
        
        
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.spacing = 10
        rowStackView.distribution = .fillEqually
        
        
        
        for i in 0..<rows{
            
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = 10
            rowStackView.distribution = .fillEqually
            
            for j in 0..<columns {
                let label = UILabel()
                label.font = UIFont(name: "Futura", size: pointSize)
               
                label.text = "\(allMatrixPositions[m].grid[i][j].fraction())"
                displayFraction(label: label, text: label.text!)
                label.adjustsFontSizeToFitWidth = true
                rowStackView.addArrangedSubview(label)
            }
            let label = UILabel()
            label.adjustsFontSizeToFitWidth = true
            label.font = UIFont(name: "Futura", size: pointSize)
            label.text = "\(allMatrixPositions[m].grid[i][4].fraction())"
            displayFraction(label: label, text: label.text!)
            rowStackView.addArrangedSubview(label)
            
            stackview.addArrangedSubview(rowStackView)
            
           
        }
        
        m += 1
        mainStackView.addArrangedSubview(stackview)
        addSpace()
        
        
    }
    
    
   
    
        func displayFraction(label: UILabel, text: String) {
            
            
            
           // let pointSize : CGFloat = 52
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
                ])
            
            
         
            let ND = text.components(separatedBy: "/")
            if(ND.count == 1){
                label.font = UIFont (name: "Futura", size: pointSize+5)
                return
            }
    //        if(ND[1] == "1"){
    //            label.font = UIFont (name: "Futura", size: 56)
    //            label.text! = ND[0]
    //        }
            else {
                label.font = UIFont(descriptor: fractionFontDesc, size:pointSize+10)
                label.text = text // note just plain numbers and a regular sl
            }
            
        }
    
    func startRowReducing() {
        
        while(matrixComplete == false){
             
                findLeadingOne()
                swapRows()
                scaleRow()
                
            if(!isUnitColumn()) {
                rowPlusRow()
            }
            
            
            //matrixComplete = true
        }
        
        print("DONE")
        rref = allMatrixPositions[m-1]
        readAnswer()
        
        
    }
    
    func readAnswer() {
        
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = UIFont(name: "Futura", size: pointSize)
        
        label.text = ""
             var rowResult: [String] = ["", "", "", ""]
             let parameters: [String] = ["u", "t", "s", "v"]
             var start: Bool = false
             var infinintelyManySolutions: Bool = false
             var noSolution: Int = -1
             let ONE: Fraction = Fraction(num: 1, den: 1)
             let ZERO: Fraction = Fraction(num: 0, den: 1)
             var currentVariable: Int = 0
             var infText: String = ""
        var listOfFractions: [String] = []
             
             
             
             // 1 0 0 -2     1 -2 0 3    1  2  0  3
             // 0 1 0 2      0  0 1 3    0  0  1  3
             // 0 0 1 3      0  0 0 0    0  0  0  0
             
             // 1 0 2/3
             // 0 1 4
             // 0 0 0
             
             for i in 0..<rows {
                 
                 // read across
                 for j in 0..<columns {
                     
                     
                     if(start == true && rref.grid[i][j].num < 0 && rref.grid[i][4] != ZERO){
                         rowResult[currentVariable] += "+\(rref.grid[i][j].negateForText())\(parameters[j])"
                        
                      }
                     else if(start == true && rref.grid[i][j].num < 0 && rref.grid[i][4] == ZERO){
                        rowResult[currentVariable] += "\(rref.grid[i][j].negateForText())\(parameters[j])"
                     }
                     else if(start == true && rref.grid[i][j].num > 0){
                         rowResult[currentVariable] += "-\(rref.grid[i][j].fraction())\(parameters[j])"
                     }
                    
                    if(rref.grid[i][j].den != 1){
                        // it's a fraction
                        listOfFractions.append(rref.grid[i][j].fraction())
                        
                    }
                     
                     
                     if rref.grid[i][j] == ONE && start == false {
                         // this is the start of the row
                         start = true
                         currentVariable = j
                         if(rref.grid[i][4] != ZERO) {
                            rowResult[currentVariable] += rref.grid[i][4].fraction()
                         }
                         
                     }
                     
                     
                 }
                 
                 if(start == true && rowResult[currentVariable] == ""){
                     rowResult[currentVariable] = rref.grid[i][4].fraction()
                 }
                
                if(rref.grid[i][4].den != 1){
                    // it's a fraction
                    listOfFractions.append(rref.grid[i][4].fraction())
                    
                }
                
                 
                 if(start == false){
                     // this column did not have any leading ones.
                     // check if it's no solution
                     if (rref.grid[i][4] != ZERO){
                         print("No solution.")
                         noSolution = i
                         break
                     }
                 }
                 
                 
                 start = false
                 
             }
             for i in 0..<columns {
              //   if rowResult[i] == "" && rref.grid[i][4] == ZERO{
                if rowResult[i] == "" {
                    var variable = ""
                     rowResult[i] = parameters[i]
                    switch i+1 {
                    case 1:
                        variable = "x"
                    case 2:
                        variable = "y"
                    case 3:
                        variable = "z"
                    default:
                        variable = "w"
                    }
                     infText += "The \(variable) column has no leading 1.  This means it can be any real number.  We will set it equal to a parameter. \n   Let \(variable) = \(parameters[i]).\n"
                     infinintelyManySolutions = true
                 }
             }
             
             if(noSolution != -1){
                print("IM IN THE NO SOLUTION PART")
                 label.text! = "This system has no solution.  If you translate Row \(noSolution+1) you get \n\n "
                 for j in 0..<columns {
                    var variable = ""
                    switch j+1 {
                    case 1:
                        variable = "x"
                    case 2:
                        variable = "y"
                    case 3:
                        variable = "z"
                    default:
                        variable = "w"
                    }
                     label.text! += "0 \(variable) + "
                 }
                 label.text!.removeLast()
                 label.text!.removeLast()
                 label.text! += "= \(rref.grid[noSolution][4].fraction())\n\nThere are no values that make this equation true."
                mainStackView.addArrangedSubview(label)
                return
             }
             
             else if (infinintelyManySolutions == true){
                 label.text! = "There are infinitely many solutions.\n"
                 label.text! += infText + "\nThe solution is...\n\n"
             }
             else {
                 label.text! = "You have a unique solution.  It is...\n\n"
             }
             
        
            label.text! += "( "
            for i in 0..<columns {
                
                label.text! += rowResult[i] + ", "
            }
            label.text!.removeLast()
            label.text!.removeLast()
        
        label.text! += " )"

        displayFractionV2(label: label, text: label.text!, list: listOfFractions)
      
             print(rowResult)
        
        mainStackView.addArrangedSubview(label)
        
//        label.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
//        label.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
//
    }
    
    func rowPlusRow() {
        var rowsArray: [Int] = []
        for i in 0..<rows{
            if(allMatrixPositions[m-1].grid[i][pivotColumn].num != 0 && i != pivotRow){
                rowsArray.append(i+1)
                rowsArray.append(pivotRow+1)
                var tempMatrix = allMatrixPositions[m-1]
                let constant = Fraction(num: -1, den: 1) * allMatrixPositions[m-1].grid[i][pivotColumn]
                tempMatrix.rowPlusConstantRow(rows: rowsArray, constant: constant)
                allMatrixPositions.append(tempMatrix)
                addRowPlusRow(reciprocal: constant, changed: rowsArray[0]-1, Pivot: rowsArray[1]-1)
                addStackView()
                return
            }
        }
        
                
        
    }
    
    func isUnitColumn() -> Bool{
        // check if it's a column of zeros
        var numberOfZeros: Int = 0
        for i in 0..<rows {
            
            if ( (allMatrixPositions[m-1].grid[i][pivotColumn] == Fraction(num: 0, den: 1))) {
                numberOfZeros += 1
            }
        }
        
    
        print("Pivot element is \(allMatrixPositions[m-1].grid[pivotRow][pivotColumn].show())")
        if (allMatrixPositions[m-1].grid[pivotRow][pivotColumn] == Fraction(num: 1, den: 1)) && (numberOfZeros == rows - 1) {
            
            // leading one and teh rest are zeros
            
            pivotRow += 1
            pivotColumn += 1
           
            if(pivotColumn >= columns){
                matrixComplete = true
            }
            print("The new pivot element is row \(pivotRow), column \(pivotColumn)")
            return true
            
            
        }
        
        else if(numberOfZeros == rows){
           
            pivotColumn += 1
            
            if(pivotColumn  >= columns) {
                matrixComplete = true
            }
            
            return true
            
        }
        
        print("not a ujit column")
        return false
        
    }
    
    func findLeadingOne() {
        foundLeadingOne = false
        leadingOneRow =  []
        foundNonZero = false
        nonZeroRow = []
        
        print("checking for leading one")
        for i in pivotRow..<rows {
            if(allMatrixPositions[m-1].grid[i][pivotColumn] == Fraction(num: 1, den: 1)){
               foundLeadingOne = true
                leadingOneRow.append(i)
                print("Found leading one in pivot spot")
                break
            }
            else if(allMatrixPositions[m-1].grid[i][pivotColumn].num != 0){
                foundNonZero = true
                nonZeroRow.append(i)
                print("Found non zero in row \(i)")
               // break

            }
        
        }
        if(foundLeadingOne == false && foundNonZero == false){
            // no 1 or non zero was found
            pivotColumn += 1
            if(pivotColumn >= columns){
                matrixComplete = true
                return
            }
            findLeadingOne()
        }
        
        
    }
    
    func swapRows() {
        
        print("checking to swap rows")
        print("leading one row", leadingOneRow)
        if(foundLeadingOne == true){
                   
            if(leadingOneRow.count > 0){
                // leading one was found
                       
                if(leadingOneRow.contains(pivotRow)){
                    // 1 is already in pivot
                    // move to 3rd row operation
                    return
                }
                       
                else {
                    // 1 was found but not in pivot row.
                    // swap
                    print("swapping to get leading one in right spot")
                    var tempMatrix = allMatrixPositions[m-1]
                    tempMatrix.swapRows(row1: pivotRow+1, row2: leadingOneRow[0]+1)
                    allMatrixPositions.append(tempMatrix)
                    addSwapRows(lhs: pivotRow, rhs: leadingOneRow[0])
                    addStackView()
                    return
                }
            }
               
        }

        else if(foundNonZero == true){
            if(pivotRow == nonZeroRow[0]){
                
                // scale row
                return
            }
            else {
                print("Swapping with non zero")
                // swap
                var tempMatrix = allMatrixPositions[m-1]
                tempMatrix.swapRows(row1: pivotRow+1, row2: nonZeroRow[0]+1)
                allMatrixPositions.append(tempMatrix)
                       
                addStackView()
                
                return
            }
                   
        }
        
       
               
    }
    
    func scaleRow() {
        
        print("checking to scale")
        
        if(allMatrixPositions[m-1].grid[pivotRow][pivotColumn] == Fraction(num: 1, den: 1)){
            // move to third row operation
            print("don't need to scale")
            return
        }
        else if(!(allMatrixPositions[m-1].grid[pivotRow][pivotColumn] == Fraction(num: 0, den: 1))){
            let reciprocal = allMatrixPositions[m-1].grid[pivotRow][pivotColumn].reciprocalAsFraction()
            var tempMatrix = allMatrixPositions[m-1]
            tempMatrix.multiplyByConstant(row: pivotRow, con: reciprocal)
            allMatrixPositions.append(tempMatrix)
            print("needed to scale. Mult by \(allMatrixPositions[m-1].grid[pivotRow][pivotColumn].reciprocal())")
            addScaleView(reciprocal: reciprocal, row: pivotRow)
            addStackView()
        }
    }
    

    func displayFractionV2(label: UILabel, text: String, list: [String]) {


             let attribString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: pointSize), NSAttributedString.Key.foregroundColor: UIColor.black])

        for fraction in list{
            attribString.addAttributes([NSAttributedString.Key.font: UIFont.fractionFont(ofSize: pointSize+4)], range: (label.text! as NSString).range(of: fraction))
        }
        

             label.attributedText = attribString

         }

}

extension UIFont
{
    static func fractionFont(ofSize pointSize: CGFloat) -> UIFont
    {
        let systemFontDesc = UIFont.systemFont(ofSize: pointSize).fontDescriptor
        let fractionFontDesc = systemFontDesc.addingAttributes(
            [
                UIFontDescriptor.AttributeName.featureSettings: [
                    [
                        UIFontDescriptor.FeatureKey.featureIdentifier: kFractionsType,
                        UIFontDescriptor.FeatureKey.typeIdentifier: kDiagonalFractionsSelector,
                    ], ]
            ] )
        return UIFont(descriptor: fractionFontDesc, size:pointSize)
    }
}


