//
//  MatrixController.swift
//  System of Equations
//
//  Created by Brian Veitch on 12/6/19.
//  Copyright © 2019 Brian Veitch. All rights reserved.
//

import UIKit

class MatrixController: UIViewController {

    @IBOutlet weak var disableScreenView: UIView!
    
    
    // keeps track of each matrix operation so we can udno if necessary
    var allMatrixPositions: [Matrix] = []
    var step: Int = 0
    
    // check if matrix is row reduced
    var matrixComplete: Bool = false
    var rowReducedMessage: Bool = false
    
    // comes from the user through segue
    var matrixOfStrings: [[String]] = []
    
    // define an emapty matrix to hold coefficients to be sent
    var matrixOfNumbers: Matrix = Matrix(rows: 4, columns: 5)
    
    // matrix size
    var numberOfRows: Int = 0
    var numberOfColumns: Int = 0
    
    var currentRow: Int = 0
    var currentCol: Int = 0
    var previousRow: [Int] = []
    var previousCol: [Int] = []
    
    // this holds which rows are to swapped
    var clickedRows: [Int] = []
    
    // the stack holding all rows and columns
    @IBOutlet weak var matrixView: UIView!
    @IBOutlet weak var matrixStackview: UIStackView!
    
    @IBOutlet weak var operationsStackview: UIStackView!
    // add labels
    @IBOutlet var row1: [UILabel]!
    @IBOutlet var row2: [UILabel]!
    @IBOutlet var row3: [UILabel]!
    @IBOutlet var row4: [UILabel]!
    
    // add row stackviews
    @IBOutlet weak var row1Stackview: UIStackView!
    @IBOutlet weak var row2Stackview: UIStackView!
    @IBOutlet weak var row3Stackview: UIStackView!
    @IBOutlet weak var row4Stackview: UIStackView!
    
    
    var alreadyDefined: Bool = false
    
    // contains the string version of the coefficients for labels
    var matrixOfLabels: [[UILabel]] = []
    
    // buttons on screen
    @IBOutlet var Operations: [UIButton]!
    
    // invalid numbrer
    var invalidNumber: Bool = false
    
    var hints: [Bool] = [true, false, false]
    
    // keep track of current pivot
    var pivotRow: Int = 0
    var pivotColumn: Int = 0
    
    // font size
    var pointSize: CGFloat = 36
    var offset: CGFloat = 0
    
    @IBOutlet weak var textForPointSize: UILabel!
    
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        firstThingsFirst()
    }
    
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
     
        addLeftBorder(with: .black, andWidth: 2)
        addRightBorder(with: .black, andWidth: 2)
        addBottomLeftBorder( with: .black, andWidth: 2)
        addBottomRightBorder( with: .black, andWidth: 2)
        addTopLeftBorder( with: .black, andWidth: 2)
        addTopRightBorder(with: .black, andWidth: 2)
        
        offset = matrixView.frame.size.width / CGFloat(numberOfColumns+1)
        addVerticalLine(with: .black, andWidth: 2)
        
    }
    
    func firstThingsFirst() {
            
        
        adjustSizes()
        
        pointSize = textForPointSize.font.pointSize
        
        for operation in Operations {
            operation.layer.cornerRadius = 10
            operation.layer.borderWidth = 1
            operation.layer.borderColor = UIColor.black.cgColor
        }
    
        numberOfRows = Int(matrixOfStrings[4][0])!
        numberOfColumns = Int(matrixOfStrings[4][1])!
        
        
        matrixOfLabels.append(row1)
        matrixOfLabels.append(row2)
        matrixOfLabels.append(row3)
        matrixOfLabels.append(row4)
        
        
        for i in 0..<matrixOfLabels.count {
            for j in 0..<matrixOfLabels[i].count {
                currentRow = i
                currentCol = j
                matrixOfLabels[i][j].isHidden = true
               
              
                if(isValidNumber(row: i, col: j)){
                   matrixOfLabels[i][j].adjustsFontSizeToFitWidth = true
                    matrixOfLabels[i][j].font = UIFont.boldSystemFont(ofSize: pointSize)
                    matrixOfLabels[i][j].text = matrixOfStrings[i][j]
                    convertToNumber(col: matrixOfLabels[i][j])
                }
                else {
                    invalidNumber = true
                    matrixOfLabels[i][j].text = "ERROR"
                }
                
            }
        }
        
        // update labels to show the numbers
        showWhatsAllowed()
        

        if(invalidNumber){
        
            disableScreenView.isUserInteractionEnabled = true
            
        }
        
        if(!invalidNumber) {
                
            // identifty the pivot
            matrixOfLabels[0][0].blink()
                
            // append the initial matrix
            allMatrixPositions.append(matrixOfNumbers)
            previousRow.append(pivotRow)
            previousCol.append(pivotColumn)
            print(previousRow, previousCol)
            isUnitColumn()
        }
    }
    

    
    func isValidNumber(row: Int, col: Int) -> Bool {
        let element = matrixOfStrings[row][col]
        
        if (element.contains("/")) {
            let ND = element.components(separatedBy: "/")
            if ND[1] == "" {
                // hanging division bar
            
                notValidMessage(message: "You didn't finish writing a fraction.")
                return false
            }
            else if (ND.count == 2 && ND[1] == "0") {
                // divide by 0
                notValidMessage(message: "You are dividing by zero.")
                return false
            }
        }
        
        return true
        
        
    }
    
    func adjustSizes() {
        operationsStackview.translatesAutoresizingMaskIntoConstraints = false
        operationsStackview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.36).isActive = true
        
        matrixStackview.translatesAutoresizingMaskIntoConstraints = false
        matrixStackview.heightAnchor.constraint(equalTo: matrixView.heightAnchor, multiplier: 1).isActive = true
        
        matrixView.translatesAutoresizingMaskIntoConstraints = false
        matrixView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
    }
    
    
    // convert string to double
    func convertToNumber(col: UILabel) {
        
        
        let element = Fraction(num: 0, den: 1)
        
        if(col.text! == "-0"){
            col.text! = "0"
        }
        
        if(col.text!.contains(".")){
        // it's a decimal
        // convert to fraction for display
                  
                    
            let decimal = Double(col.text!)!
                
            let (h,k): (Int,Int) = rAof(x0: abs(decimal))
                // add to matrixOfNumbers
            if(decimal < 0){
                element.isNegative = true
                element.update(-1*h,k)
            }
            else {
                element.isNegative = false
                element.update(h, k)
            }
               
            col.text! = element.fraction()
                    
            displayFraction(label: col, text: col.text!)
        }
            
        else if( col.text!.contains("/")){
            // it's a fraction'
                    
            let numeratorDenonimator = col.text!.components(separatedBy: "/")
            let numerator = Int(numeratorDenonimator[0])!
            
            if(numerator < 0){
               element.isNegative = true
            }
            
            var denominator = 1
            
            if (Int(numeratorDenonimator[1]) != nil) {
                denominator = Int(numeratorDenonimator[1])!
            }
            
            
            
            
            element.update(numerator, denominator)
                    
            element.reduce()
                   
            col.text! = element.fraction()
            
            displayFraction(label: col, text: col.text!)
                    
        }
            
        if(!col.text!.contains(".") && !col.text!.contains("/")){
            // it's an integer
            let number = Int(col.text!)!
            if(number < 0){
                element.isNegative = true
            }
            element.update(number, 1)
        }
        
        matrixOfNumbers.grid[currentRow][currentCol] = element
        
    }
    
    // converts double to fraction
    func rAof (x0: Double, withPrecision eps: Double = 1.0E-6) -> (Int,Int) {
        var x = x0
        var a = floor(x)
        var (h1, k1, h, k) = (1,0,Int(a), 1)
        
        while( x-a > eps * Double(k)*Double(k)){
            x = 1.0/(x-a)
            a = floor(x)
            (h1,k1,h,k) = (h,k,h1+Int(a)*h, k1+Int(a)*k)
        }
        
        
        return (h,k)
        
        
    }
    
    func showWhatsAllowed() {
        // show what's allowed
        for i in 0..<numberOfRows {
            for j in 0..<numberOfColumns {
                matrixOfLabels[i][j].isHidden = false
            }
            matrixOfLabels[i][4].isHidden = false
        }
    }

    func addTopLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]

        border.frame = CGRect(x: 0, y: 0, width: 10, height: borderWidth)
        matrixView.addSubview(border)
    }
    
    func addTopRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth]
   
        border.frame = CGRect(x: matrixView.frame.size.width - 10, y: 0, width: 10, height: borderWidth)
            matrixView.addSubview(border)
        }
    
    func addBottomLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        var yLocation = matrixView.frame.size.height
        yLocation = CGFloat(Float(yLocation) * Float(numberOfRows)/4)
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y: yLocation, width:10, height: borderWidth)
        matrixView.addSubview(border)
    }
    
    func addBottomRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        var yLocation = matrixView.frame.size.height
        yLocation = CGFloat(Float(yLocation) * Float(numberOfRows)/4)
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: matrixView.frame.size.width-10, y: yLocation, width:10, height: borderWidth)
        matrixView.addSubview(border)
    }

    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        
    var lineHeight =  matrixView.frame.size.height
        lineHeight = CGFloat(Float(lineHeight) * Float(numberOfRows)/4)
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: lineHeight)
        
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        matrixView.addSubview(border)
    }

    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        var lineHeight =  matrixView.frame.size.height
        lineHeight = CGFloat(Float(lineHeight) * Float(numberOfRows)/4)
        
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: matrixView.frame.size.width - borderWidth, y: 0, width: borderWidth, height: lineHeight)
        matrixView.addSubview(border)
    }
    
    func addVerticalLine(with color: UIColor?, andWidth borderWidth: CGFloat) {
        var lineHeight =  matrixView.frame.size.height
        lineHeight = CGFloat(Float(lineHeight) * Float(numberOfRows)/4)
        
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: matrixView.frame.size.width - offset, y: 0, width: borderWidth, height: lineHeight)
        matrixView.addSubview(border)
        
       
    }
    
    func displayFraction(label: UILabel, text: String) {
        // displayFraction(label: matrixOfButtons[currentRow][currentCol])
        //let pointSize : CGFloat = 36
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
        if(ND[1] == "1"){
            label.font = UIFont (name: "Futura", size: pointSize)
            label.text! = ND[0]
        }
        else {
            label.font = UIFont(descriptor: fractionFontDesc, size:pointSize+10)
            label.text! = text // note just plain numbers and a regular sl
        }
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        
        
    }
    
    func displayFractionNew(label: UILabel, text: String) {
        // displayFraction(label: matrixOfButtons[currentRow][currentCol])
      //  let pointSize : CGFloat = 36
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
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
    }
    
    func updateMatrixOfLabels() {
        
        for i in 0..<matrixOfLabels.count {
            for j in 0..<matrixOfLabels[i].count {
                let fraction = "\(matrixOfNumbers.grid[i][j].num)/\(matrixOfNumbers.grid[i][j].den)"
                displayFractionNew(label: matrixOfLabels[i][j], text: fraction)
            }
        }
    }
    
    

    
    // buttons
    
    @IBAction func swapRows(_ sender: Any) {
      
    }
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
        if(invalidNumber){
            return
        }
        if(segue.identifier == "testSegue") {
             
           // let vc = segue.destination as! TestController
//            vc.matrix = matrixOfNumbers

        }
         if(segue.identifier == "SwapRows") {
             
            let vc = segue.destination as! SwapRowsController
            vc.delegate = self
            vc.numberOfEquations = numberOfRows
        }
        if(segue.identifier == "MultiplyByConstantController") {
             
            let vc = segue.destination as! MultiplyByConstantController
            vc.delegate = self
            vc.numberOfEquations = numberOfRows
        }
        
        if(segue.identifier == "RowPlusConstantRowController") {
             
            let vc = segue.destination as! RowPlusConstantRowController
            vc.delegate = self
            vc.numberOfEquations = numberOfRows
        }
        
        if(segue.identifier == "HintSegue") {
             
            let vc = segue.destination as! HintController
           
            // get the matrixofnumbers together
            
            
            vc.delegate = self
            vc.matrix = matrixOfNumbers
            vc.rows = numberOfRows
            vc.columns = numberOfColumns
            vc.hints = hints
            vc.pivotColumn = pivotColumn
            vc.pivotRow = pivotRow
            vc.matrixComplete = matrixComplete
        }
        
         if(segue.identifier == "SolutionSegue") {
             let vc = segue.destination as! SolutionController
            // vc.delegate = self
            vc.matrix = matrixOfNumbers
            vc.rows = numberOfRows
            vc.columns = numberOfColumns
         }
         
     }
    
    @IBAction func undoAction(_ sender: Any) {
        
        
        if(step > 0){
            
            step -= 1
        
            for i in 0..<matrixOfLabels.count {
                for j in 0..<matrixOfLabels[i].count {
                    let fraction = "\(allMatrixPositions[step].grid[i][j].num)/\(allMatrixPositions[step].grid[i][j].den)"
                    displayFractionNew(label: matrixOfLabels[i][j], text: fraction)
                }
            }
            
            
            allMatrixPositions.removeLast()
            matrixOfNumbers = allMatrixPositions[step]
            print("there are \(step+1), \(allMatrixPositions.count) total matrices.")
            
            matrixOfLabels[pivotRow][pivotColumn].stopBlink()
           pivotRow = previousRow[step]
           previousRow.removeLast()
           pivotColumn = previousCol[step]
           previousCol.removeLast()
            print(previousRow, previousCol)
            matrixOfLabels[pivotRow][pivotColumn].blink()
            
            rowReducedMessage = false
            matrixComplete = false
                
        }
        
    }
    
    
    
    func openPopUpMessage(message: String) {
        print(message)
        
        //
        let vc = storyboard?.instantiateViewController(withIdentifier: "CompleteColumnPopup") as! CompleteColumnPopup
        vc.message = message
        self.present(vc, animated: true, completion: nil)
    }
    
    func notValidMessage(message: String) {
    
        let vc = storyboard?.instantiateViewController(withIdentifier: "validNumberController") as! validNumberController
          vc.message = message
          self.present(vc, animated: true, completion: nil)
      }
    
    
    
    func isUnitColumn()  {
        
        if(rowReducedMessage == true){
            return
        }
        
        var messageToUser: String = ""
        let ZERO = Fraction(num: 0, den: 1)
        let ONE = Fraction(num: 1, den: 1)
        
        if(pivotColumn >= numberOfColumns && rowReducedMessage == false){
            
            messageToUser += "Your matrix is in Row Reduced Form.\n"
            messageToUser += "Read your answer from the matrix.\n"
            openPopUpMessage(message: messageToUser)
            rowReducedMessage = true
            return
        }
        
        var numberOfZeros: Int = 0
        var numberOfEligibleRows: Int = 0
        
        for i in 0..<numberOfRows {
            if (matrixOfNumbers.grid[i][pivotColumn] == ZERO) {
                numberOfZeros += 1
            }
            
            else if (i >= pivotRow) {
                numberOfEligibleRows += 1
            }
            
        }
    
        
        // ROW IS REDUCED
        if (matrixOfNumbers.grid[pivotRow][pivotColumn] == ONE) && (numberOfZeros == numberOfRows - 1) {
            
            // leading one and teh rest are zeros
            messageToUser += "You completed one round of Row Reducing.\n"
            messageToUser += "Your pivot element is moved the next row and column.\n"
          
            
            matrixOfLabels[pivotRow][pivotColumn].stopBlink()
            
            pivotRow += 1
            pivotColumn += 1
            previousRow[step] = pivotRow
            previousCol[step] = pivotColumn
            print(previousRow, previousCol)
            matrixOfLabels[pivotRow][pivotColumn].blink()
            hints = [true, false, false]
            
            if(pivotColumn >= numberOfColumns || pivotRow >= numberOfRows){
                
                if(rowReducedMessage == false){
                    messageToUser = "Your matrix is in Row Reduced Form.\n"
                    messageToUser += "Read your answer from the matrix.\n"
                }
                rowReducedMessage = true
                
                
                matrixComplete = true
               
            }
            
            openPopUpMessage(message: messageToUser)
            
        }
        
        else if(numberOfEligibleRows == 0){
          
            matrixOfLabels[pivotRow][pivotColumn].stopBlink()
            
            pivotColumn += 1
            matrixOfLabels[pivotRow][pivotColumn].blink()
                previousRow[step] = pivotRow
                previousCol[step] = pivotColumn
            
            print(previousRow, previousCol)
            if(pivotColumn >= numberOfColumns ){
               
                if(rowReducedMessage == false) {
                    messageToUser = "You've completed the Row Reduction.  Read your answer from the matrix. 1\n"
                    rowReducedMessage = true
                    return
                }
                
            } else {
                // you have a row of 0s
                messageToUser += "You have no eligible rows to have a leading one.\n"
                messageToUser += "Your pivot column is moved to the right.\n"
            }
            
            
            print(messageToUser)
            openPopUpMessage(message: messageToUser)
            
            
            hints = [true, false, false]
           
            
        }
        else {
            print("STUFF HAPPENS")
        }
        
        
        
//        if(foundLeadingOne == false){
//            // you can't have a leading one
//            messageToUser += "There are no eligible rows in the current pivot column to have a leading one.\n"
//            messageToUser += "Your pivot column is moved to the right.\n"
//            openPopUpMessage(message: messageToUser)
//            matrixOfLabels[pivotRow][pivotColumn].stopBlink()
//            pivotColumn += 1
//            matrixOfLabels[pivotRow][pivotColumn].blink()
//            hints = [true, false, false]
//
//
//        }
//
//        return
        
        
        
        
    }
    
}

extension MatrixController: hintDelegate {
    func getHint(hints: [Bool], pivotRow: Int, pivotColumn: Int) {
        self.hints = hints
        self.pivotRow = pivotRow
        self.pivotColumn = pivotColumn
        self.matrixOfLabels[pivotRow][pivotColumn].blink()
        if(pivotRow != 0 && pivotColumn != 0){
            self.matrixOfLabels[pivotRow-1][pivotColumn-1].stopBlink()
        }
        
        isUnitColumn()
    }
    
}

extension MatrixController: SwapRowsDelegate {
    func swapRowsSelected(rows: [Int]) {
        step += 1
        clickedRows = rows
        var newMatrix = matrixOfNumbers
        newMatrix.swapRows(row1: clickedRows[0], row2: clickedRows[1])
        allMatrixPositions.append(newMatrix)
        previousRow.append(pivotRow)
        previousCol.append(pivotColumn)
        matrixOfNumbers = newMatrix
        updateMatrixOfLabels()
        
        
    
        
        for i in 0..<pivotRow {
            if (clickedRows.contains(i+1)){
                openPopUpMessage(message: "Row \(i+1) was a completed row, meaning it's a row with a leading 1. You should never swap a completed row.  Please UNDO your last step.")
                return
            }
        }
        
        isUnitColumn()
        
    }
}

extension MatrixController:  MultiplyByConstantDelegate {
    func getConstant(row: Int, multiplyBy: Fraction) {
        step += 1
        var newMatrix = matrixOfNumbers
        newMatrix.multiplyByConstant(row: row, con: multiplyBy)
        allMatrixPositions.append(newMatrix)
        previousRow.append(pivotRow)
        previousCol.append(pivotColumn)
        matrixOfNumbers = newMatrix
        print(previousRow, previousCol)

        updateMatrixOfLabels()
       
       
        if(multiplyBy == Fraction(num: 0, den: 1)){
            openPopUpMessage(message: "You should never multiply a row by 0...ever.  Please UNDO your last step.")
            return
        }
        
        for i in 0..<pivotRow {
            if (i == row){
                openPopUpMessage(message: "Row \(i+1) was a completed row, meaning it's a row with a leading 1. You should never multiply a completed row by a constant.  Please UNDO your last step.")
                return
            }
        }
        
        isUnitColumn()
               
    }
}

extension MatrixController: RowPlusConstantRowDelegate {
    func getInfo(rows: [Int], constant: Fraction) {
        step += 1
        var newMatrix = matrixOfNumbers
        newMatrix.rowPlusConstantRow(rows: rows, constant: constant)
        allMatrixPositions.append(newMatrix)
        previousRow.append(pivotRow)
        previousCol.append(pivotColumn)
        print(previousRow, previousCol)
        matrixOfNumbers = newMatrix
        updateMatrixOfLabels()
        
        isUnitColumn()
               
    }
    
}


