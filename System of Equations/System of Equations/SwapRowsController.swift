//
//  SwapRowsController.swift
//  System of Equations
//
//  Created by Brian Veitch on 12/9/19.
//  Copyright © 2019 Brian Veitch. All rights reserved.
//

import UIKit

class SwapRowsController: UIViewController {

    var numberOfEquations: Int = 2
    
    var delegate: SwapRowsDelegate?
    
    @IBOutlet var rowButtons: [UIButton]!
    @IBOutlet weak var swapButton: UIButton!
    
    @IBOutlet weak var mainView: CommonButton!
    
    @IBOutlet weak var leftRow: UIImageView!
    @IBOutlet weak var rightRow: UIImageView!
    
    @IBOutlet weak var operationStackview: UIStackView!
    
    // keep track of which two buttons are clicked
    var clickedRows: [Int] = [0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for button in rowButtons {
            button.layer.cornerRadius = button.frame.height/4
            if(button.tag > numberOfEquations){
                button.isHidden = true
            }
        }
      
        adjustSizes()
        
    }
    
    func adjustSizes() {
       
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        operationStackview.translatesAutoresizingMaskIntoConstraints = false
        operationStackview.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
    }
    
    @IBAction func clickRows(_ sender: UIButton) {
        
        
        if(clickedRows.contains(sender.tag)){
            if let index = clickedRows.firstIndex(where: {$0 ==  sender.tag}) {
                if(clickedRows[0] == sender.tag){
                    leftRow.image = UIImage(named: "")
                    clickedRows[index] = 0
                }
                else {
                    rightRow.image = UIImage(named: "")
                    clickedRows[index] = 0
                }
                
                
            }
            rowButtons[sender.tag-1].backgroundColor = UIColor(red: 11/255, green: 49/255, blue: 92/255, alpha: 1.00)
        }
        else {
            
            if !(clickedRows.contains(0)) {
                return
            }
            
            if let index = clickedRows.firstIndex(where: {$0 ==  0}) {
                if (index == 0){
                    leftRow.image = UIImage(named: "R\(sender.tag)")
                    clickedRows[index] = sender.tag
                }
                else if(index == 1){
                    rightRow.image = UIImage(named: "R\(sender.tag)")
                    clickedRows[index] = sender.tag
                }
                else {
                    return
                }
            }
        
            rowButtons[sender.tag-1].backgroundColor = UIColor.red
         
            
        }
        
        
        
    }
    
    @IBAction func swapAction(_ sender: Any) {
        if(!clickedRows.contains(0)){
            dismiss(animated: true) {
                self.delegate?.swapRowsSelected(rows: self.clickedRows)
            }
        }
        
    }
    

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
}

protocol SwapRowsDelegate {
    func swapRowsSelected(rows: [Int])
}
