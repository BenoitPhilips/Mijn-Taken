//
//  ViewController.swift
//  Mijn Taken test
//
//  Created by Benoit Philips on 05/04/2019.
//  Copyright © 2019 HumbeekWave. All rights reserved.
//

import UIKit

class MijnLijstViewController: UITableViewController {

    let TakenLijst = ["Boodschappen 7/11", "Boodschappen Big C", "Bellen naar"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TakenLijst.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaakItemCell", for: indexPath)
        cell.textLabel?.text=TakenLijst[indexPath.row]
        // De checkbox staat aan zelfs als we in XCode dat bij de viewcontroller op default hebben ingesteld.
        cell.accessoryType = .none
        return cell
    }
    
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
            // Geselecteerde rij vervangen we door niet geselecteerd en markeren/demarkeren met een checkmark
        tableView.deselectRow(at: indexPath, animated: true)

        // Volgende if statement kan compacter :
        //        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        // Zoals hieronder volgt...
        
        tableView.cellForRow(at: indexPath)?.accessoryType = (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) ? .none : .checkmark
   }
}

