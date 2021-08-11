//
//  SideMenuVC.swift
//  System of Equations
//
//  Created by Brian Veitch on 12/11/19.
//  Copyright © 2019 Brian Veitch. All rights reserved.
//

import UIKit

class SideMenuVC: UITableViewController {

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }

}
