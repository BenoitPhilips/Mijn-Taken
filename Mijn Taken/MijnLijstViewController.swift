//
//  ViewController.swift
//  Mijn Taken test 
//
//  Created by Benoit Philips on 05/04/2019.
//  Copyright © 2019 HumbeekWave. All rights reserved.
//

import UIKit
import CoreData

//==================================================================================================

class MijnLijstViewController: UITableViewController {

    let mijnTaken = CDTakenLijst()
 
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        mijnTaken.load()
        navigationController?.navigationItem.setHidesBackButton(false, animated: true)
        
    }

    //----------------------------------------------------------------------------------------------------------
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mijnTaken.lijst.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaakItemCell", for: indexPath)
        cell.textLabel?.text=mijnTaken.lijst[indexPath.row].naam
        // De checkbox staat aan zelfs als we in XCode dat bij de viewcontroller op default hebben ingesteld.
        cell.accessoryType = mijnTaken.lijst[indexPath.row].checked ? .checkmark : .none
        return cell
    }
    
    //----------------------------------------------------------------------------------------------------------
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Geselecteerde rij vervangen we door niet geselecteerd en markeren/demarkeren met een checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        mijnTaken.lijst[indexPath.row].checked = !mijnTaken.lijst[indexPath.row].checked
        tableView.reloadData()
        mijnTaken.save()
    }

    //----------------------------------------------------------------------------------------------------------
    //MARK: - opvang van de buttons
    
//
//    @IBAction func terugNaarCatBtnPressed(_ sender: UIBarButtonItem) {
//         dismiss(animated: true, completion: nil)
//    }
//
    @IBAction func nieuweTaakBtnPressed(_ sender: UIBarButtonItem) {
        var nieuweTaakTxtFld = UITextField()
        
        let alert = UIAlertController(title: "Maak een nieuwe Te Doen", message: "", preferredStyle: .alert)
        
        let actie = UIAlertAction(title: "Nieuwe Te Doen", style: .default) { (actie) in
            //klik op de "Nieuwe Taak"-button wordt hier verwerkt
            if let nieuweTaakTxt = nieuweTaakTxtFld.text {
                if nieuweTaakTxt != "" {
                    self.mijnTaken.append(nieuweTaakTxt)
                    self.tableView.reloadData()
                    self.mijnTaken.save()
                }
            }
        }
        alert.addAction(actie)
        
        alert.addTextField { (alertTxtFld) in
            alertTxtFld.placeholder = "omschrijving van de nieuwe taak"
            nieuweTaakTxtFld = alertTxtFld
        }
        
        present(alert,animated: true,completion: nil)
    }
}

//==================================================================================================
//MARK: - SearchBar functions

extension MijnLijstViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async{
            searchBar.resignFirstResponder() // hide keyboard and cursor in searchfield
        }
      if let filter = searchBar.text {
            mijnTaken.load(filter)
        } else {
        mijnTaken.load()
       }
        self.tableView.reloadData()
    }
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async{
                searchBar.resignFirstResponder() // hide keyboard and cursor in searchfield
            }
            mijnTaken.load()
            self.tableView.reloadData()
        }
    }
}

//==================================================================================================
