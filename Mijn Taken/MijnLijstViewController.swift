//
//  ViewController.swift
//  Mijn Taken test
// OK broken zit in master
//
//  Created by Benoit Philips on 05/04/2019.
//  Copyright © 2019 HumbeekWave. All rights reserved.
//

import UIKit
import RealmSwift

//==================================================================================================

class MijnLijstViewController: SwipeTableViewController {

    let mijnTaken = RealmTakenLijst()
 
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = mijnTaken.gekozenCat?.naam
    }

    //----------------------------------------------------------------------------------------------------------
    //MARK: - Tableview Datasource Methods
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mijnTaken.takenLijst?.count  ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
         if let toDo = mijnTaken.takenLijst?[indexPath.row] {
            cell.textLabel?.text = toDo.naam
            cell.accessoryType = toDo.checked ? .checkmark : .none
            cell.tintColor = UIColor.black
        } else {
            cell.textLabel?.text = "Nog geen Te Doen voor '\(mijnTaken.gekozenCat!.naam)'"
        }
        return cell
    }
    
     //----------------------------------------------------------------------------------------------------------
    //MARK: - TableView Delegate methods
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Geselecteerde rij vervangen we door niet geselecteerd en markeren/demarkeren met een checkmark
       
        if let toDo = mijnTaken.takenLijst?[indexPath.row] {
            mijnTaken.updateChecked(toDo, !toDo.checked)
            tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //----------------------------------------------------------------------------------------------------------
    //MARK: - opvang van de buttons
    //
    @IBAction func nieuweTaakBtnPressed(_ sender: UIBarButtonItem) {
        var nieuweTaakTxtFld = UITextField()
        
        let alert = UIAlertController(title: "Maak een nieuwe Te Doen", message: "", preferredStyle: .alert)
        
        let actie = UIAlertAction(title: "Nieuwe Te Doen", style: .default) { (actie) in
            //klik op de "Nieuwe Taak"-button wordt hier verwerkt
            if let nieuweTaakTxt = nieuweTaakTxtFld.text {
                if nieuweTaakTxt != "" { //TODO: Hier zou nog een controle moeten komen mocht de ToDo/Taak reeds bestaan
                    self.mijnTaken.appendAndSave(nieuweTaakTxt)
                    self.tableView.reloadData()
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
    
    //----------------------------------------------------------------------------------------------------------
    //MARK: - opvang van de swipe van een cell (bij verwijderen)
    //
    override func deleteDataInModel (at indexPath : IndexPath) {
        if let TaakToDelete = self.mijnTaken.takenLijst?[indexPath.row] {
            self.mijnTaken.deleteTaak(TaakToDelete)
        } else {
            print("BPH: no To Do selected for deletion")
        }
    }
    
    //----------------------------------------------------------------------------------------------------------
    //MARK: - searchbar op ViewController bereikbaar maken
    //
    @IBOutlet weak var searchBar: UISearchBar!
    
}

//==================================================================================================
//MARK: - SearchBar functions
//
extension MijnLijstViewController: UISearchBarDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.barTintColor = altCellColor
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async{
            searchBar.resignFirstResponder() // hide keyboard and cursor in searchfield
        }
      if let filter = searchBar.text {
            mijnTaken.loadTaken(filter)
        } else {
            mijnTaken.loadTaken()
       }
        self.tableView.reloadData()
    }
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async{
                searchBar.resignFirstResponder() // hide keyboard and cursor in searchfield
            }
            mijnTaken.loadTaken()
            self.tableView.reloadData()
        }
    }
}

//==================================================================================================
