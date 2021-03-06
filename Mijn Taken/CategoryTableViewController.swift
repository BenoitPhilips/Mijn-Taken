// This version is recovered and becomes a new master2
// Making a new commit
//
//  CategoryTableViewController.swift
//  Mijn Taken
//
//  Created by Benoit Philips on 10/04/2019.
//  Copyright © 2019 HumbeekWave. All rights reserved.
//

import UIKit
import CoreData

//==================================================================================================

class CategoryTableViewController: UITableViewController {

    let myCat = CDCategoriesLijst()

    //----------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(myCat.mijnDB)
        myCat.load()
    }
    
    //----------------------------------------------------------------------------------------------------------
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCat.lijst.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatItemCell", for: indexPath)
        cell.textLabel?.text=myCat.lijst[indexPath.row].naam
        return cell
    }
    
    //----------------------------------------------------------------------------------------------------------
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Geselecteerde rij vervangen we door niet geselecteerd en markeren/demarkeren met een checkmark
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "GaNaarTedoen", sender: self)
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MijnLijstViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.mijnTaken.gekozenCat = myCat.lijst[indexPath.row]
        } else {
            print("BPH: geen indexpath gevonden voor de geselecteerde rij")
        }
    }
    
  //----------------------------------------------------------------------------------------------------------
    //MARK: - opvang van de buttons
    @IBAction func addCatBtnPressed(_ sender: UIBarButtonItem) {
       
        var nieuweCatTxtFld = UITextField()
        
        let alert = UIAlertController(title: "Maak een nieuwe taak", message: "", preferredStyle: .alert)
        
        let actie = UIAlertAction(title: "Nieuwe taak", style: .default) { (actie) in
            //klik op de "Nieuwe Categorie"-button wordt hier verwerkt
            if let nieuweCatTxt = nieuweCatTxtFld.text {
                if nieuweCatTxt != "" {
                    self.myCat.append(nieuweCatTxt)
                    self.tableView.reloadData()
                    self.myCat.save()
                }
            }
        }
        alert.addAction(actie)
        
        alert.addTextField { (alertTxtFld) in
            alertTxtFld.placeholder = "omschrijving van de nieuwe category"
            nieuweCatTxtFld = alertTxtFld
        }
        
        present(alert,animated: true,completion: nil)
    }
    
    
}

//==================================================================================================
//MARK: - SearchBar functions

extension CategoryTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async{
            searchBar.resignFirstResponder() // hide keyboard and cursor in searchfield
        }
        if let filter = searchBar.text {
            myCat.load(filter)
        } else {
            myCat.load()
        }
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async{
                searchBar.resignFirstResponder() // hide keyboard and cursor in searchfield
            }
            myCat.load()
            self.tableView.reloadData()
        }
    }
}

//==================================================================================================
