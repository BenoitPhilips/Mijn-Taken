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

//==================================================================================================

class CategoryTableViewController: SwipeTableViewController {

    let myCat = RealmCategoriesLijst()
     
    //----------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        myCat.loadCategories()
        //tableView.rowHeight = 80.0
    }
    
    //----------------------------------------------------------------------------------------------------------
    //MARK: - Tableview Datasource Methods
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCat.categoryLijst?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text=myCat.categoryLijst?[indexPath.row].naam ?? "Nog geen Taken aangemaakt"
        return cell
    }
    
    //----------------------------------------------------------------------------------------------------------
    //MARK: - TableView Delegate methods
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    //
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
    
    //----------------------------------------------------------------------------------------------------------
    //MARK: - opvang van de swipe van een cell (bij verwijderen)
    //
    override func deleteDataInModel (at indexPath : IndexPath) {
        if let catToDelete = self.myCat.categoryLijst?[indexPath.row] {
            self.myCat.deleteCategory(catToDelete)
        } else {
            print("BPH: no taak selected for deletion")
        }
    }
}

//==================================================================================================
//MARK: - SearchBar functions
//
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
//MARK: - HexColor selection
//
extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

//==================================================================================================
