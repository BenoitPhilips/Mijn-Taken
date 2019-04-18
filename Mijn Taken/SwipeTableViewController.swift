//
//  SwipeTableViewController.swift
//  Mijn Taken
//
//  Created by Benoit Philips on 18/04/2019.
//  Copyright © 2019 HumbeekWave. All rights reserved.
//

import UIKit
import SwipeCellKit

//==================================================================================================

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    let altCellColor = UIColor(hex: "#bbbcc2ff")
    let navBarColor = UIColor(hex: "#0096ffff")

    override func viewDidLoad() {
        super.viewDidLoad()
     
        guard let navBar = navigationController?.navigationBar else {
            fatalError("BPH: no navigationbar as navigation controller was not loaded")
        }
        navBar.barTintColor = navBarColor
      }

    //----------------------------------------------------------------------------------------------------------
    //MARK: - Tableview Datasource Methods
    //
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SwipeableCell", for: indexPath) as! SwipeTableViewCell
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = UIColor.white
        } else {
            cell.contentView.backgroundColor = altCellColor
        }
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            // handle deleteAction by updating model with deletion
            self.deleteDataInModel(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func deleteDataInModel (at indexPath : IndexPath) {
        // This method should be overrided in the controller inheriting from actual SwipeViewController
        // if not, no deletion will happen
    }

}

//==================================================================================================

