//
//  Categorieën.swift
//  Mijn Taken
//
//  Created by Benoit Philips on 09/04/2019.
//  Copyright © 2019 HumbeekWave. All rights reserved.
//

import UIKit
import RealmSwift

class RealmCategoriesLijst {
    
    //Next statement should be required, but according manual, we can use forced unwrapped
    //    do {
    //        let realm = try Realm()
    //    } catch {
    //        print("BPH: Error initialising new Realm, \(Error)")
    //    }
    let realmDB = try! Realm()
    
    var categoryLijst : Results<RealmCategory>? 
    
    func appendAndSave(_ CatNaam : String){
        let nieuweCat = RealmCategory()
        nieuweCat.naam = CatNaam
        do {
            try realmDB.write {
                realmDB.add(nieuweCat)//Appends to Categorylijst and save
            }
        } catch {
            print("BPH: Error saving nieuwe Category \(error)")
        }
    }
    
    func loadCategories () {
        categoryLijst = realmDB.objects(RealmCategory.self)//.sorted(byKeyPath: "naam", ascending: true)
    }
    
    func loadCategories (_ CatNaamTeSelecteren : String){
         if CatNaamTeSelecteren == "" {
            loadCategories()
         } else {
            categoryLijst = categoryLijst?.filter("naam CONTAINS[cd] %@", CatNaamTeSelecteren).sorted(byKeyPath: "naam", ascending: true)
        }
    }
    
    func deleteCategory (_ catToDelete : RealmCategory) {
         do {
            try realmDB.write {
                realmDB.delete(catToDelete)
            }
        } catch {
            print("BPH: Error deleting Taak \(catToDelete.naam) : \(error)")
        }
    }

}
