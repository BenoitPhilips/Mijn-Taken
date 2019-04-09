//
//  ViewController.swift
//  Mijn Taken test
//
//  Created by Benoit Philips on 05/04/2019.
//  Copyright © 2019 HumbeekWave. All rights reserved.
//

import UIKit

class MijnLijstViewController: UITableViewController {

    let mijnTaken = NSTakenLijst()
    let mijnTakenSleutel : String = "MijnTakenSleutelV1" //Om de mijn Taken Lijst te bewaren in the defaults (PList)

    //----------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mijnTaken.load(sleutel: mijnTakenSleutel)
     }

    //----------------------------------------------------------------------------------------------------------
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mijnTaken.lijst.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaakItemCell", for: indexPath)
        cell.textLabel?.text=mijnTaken.lijst[indexPath.row].taak
        // De checkbox staat aan zelfs als we in XCode dat bij de viewcontroller op default hebben ingesteld.
        cell.accessoryType = mijnTaken.lijst[indexPath.row].taakChecked ? .checkmark : .none
        return cell
    }
    
    //----------------------------------------------------------------------------------------------------------
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Geselecteerde rij vervangen we door niet geselecteerd en markeren/demarkeren met een checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        mijnTaken.lijst[indexPath.row].taakChecked = !mijnTaken.lijst[indexPath.row].taakChecked
        tableView.reloadData()
        mijnTaken.save(sleutel: mijnTakenSleutel)
   }

    //----------------------------------------------------------------------------------------------------------
  @IBAction func nieuweTaakBtnPressed(_ sender: UIBarButtonItem) {
        var nieuweTaakTxtFld = UITextField()
        
        let alert = UIAlertController(title: "Maak een nieuwe taak", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Nieuwe taak", style: .default) { (action) in
            //klik op de "Nieuwe Taak"-button wordt hier verwerkt
            if let nieuweTaakTxt = nieuweTaakTxtFld.text {
                if nieuweTaakTxt != "" {
                    self.mijnTaken.append(nieuweTaakTxt)
                    self.tableView.reloadData()
                    self.mijnTaken.save(sleutel: self.mijnTakenSleutel)
                    
                }
            }
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTxtFld) in
            alertTxtFld.placeholder = "omschrijving van de nieuwe taak"
            nieuweTaakTxtFld = alertTxtFld
        }
        
        present(alert,animated: true,completion: nil)

        
    }
    
    
}

