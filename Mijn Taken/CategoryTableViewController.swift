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
import RealmSwift
import SwipeCellKit

//==================================================================================================

class CategoryTableViewController: UITableViewController {

    let myCat = RealmCategoriesLijst()

    //----------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        myCat.loadCategories()
        //tableView.rowHeight = 80.0
    }
    
    //----------------------------------------------------------------------------------------------------------
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCat.categoryLijst?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatItemCell", for: indexPath) as! SwipeTableViewCell
        cell.textLabel?.text=myCat.categoryLijst?[indexPath.row].naam ?? "Nog geen Taken aangemaakt"
        cell.delegate = self
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
            destinationVC.mijnTaken.gekozenCat = myCat.categoryLijst![indexPath.row]
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
                if nieuweCatTxt != "" { //ToDo: Hier zou ook moeten getest worden of de neiuwe category reeds bestaat
                    self.myCat.appendAndSave(nieuweCatTxt)
                    self.tableView.reloadData()
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
            myCat.loadCategories(filter)
        } else {
            myCat.loadCategories()
        }
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async{
                searchBar.resignFirstResponder() // hide keyboard and cursor in searchfield
            }
            myCat.loadCategories()
            self.tableView.reloadData()
        }
    }
}

//==================================================================================================
//MARK: - Swipe Cell Delegate functions

extension CategoryTableViewController: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            // handle deleteAction by updating model with deletion
            if let catToDelete = self.myCat.categoryLijst?[indexPath.row] {
                self.myCat.deleteCategory(catToDelete)
            } else {
                print("BPH: no category selected for deletion")
            }
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
    
}
