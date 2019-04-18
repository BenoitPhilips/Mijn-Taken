//
//  TakenLijst.swift
//  Mijn Taken
//
//  Created by Benoit Philips on 09/04/2019.
//  Copyright © 2019 HumbeekWave. All rights reserved.
//

import UIKit
import RealmSwift

//==================================================================================================

class RealmTakenLijst {
    
    let realmDB = try! Realm()

    var takenLijst : Results<RealmTaak>?
    var gekozenCat : RealmCategory? {
        didSet {
            loadTaken()
        }
    }
    
    func appendAndSave(_ taakNaam : String, _ taakChecked : Bool){
         do {
            try realmDB.write {
                let nieuweTaak = RealmTaak()
                nieuweTaak.naam = taakNaam
                nieuweTaak.checked = taakChecked
                gekozenCat!.realmTakenLijst.append(nieuweTaak)
          }
        } catch {
            print("BPH: Error saving nieuwe To Do \(error)")
        }
   }
    
    func appendAndSave(_ taakNaam : String){
        appendAndSave(taakNaam, false)
    }
    
    func updateChecked(_ toDo : RealmTaak,_ checkedStatus : Bool) {
        do {
            try realmDB.write {
                toDo.checked = checkedStatus
            }
        } catch {
            print("BPH : Error saving checked status : \(error)")
        }
    }
    
    func loadTaken() {
        takenLijst = gekozenCat?.realmTakenLijst.sorted(byKeyPath: "naam", ascending: true)
    }
        
    func loadTaken (_ taakNaamTeSelecteren : String){
        if taakNaamTeSelecteren == "" {
            loadTaken()
        } else {
            takenLijst = takenLijst?.filter("naam CONTAINS[cd] %@", taakNaamTeSelecteren).sorted(byKeyPath: "naam", ascending: true)
        }
    }
    
    func deleteTaak (_ toDoToDelete : RealmTaak) {
        do {
            try realmDB.write {
                realmDB.delete(toDoToDelete)
            }
        } catch {
            print("BPH: Error deleting To Do \(toDoToDelete.naam) : \(error)")
        }
     }

}

//==================================================================================================
