//
//  TakenLijst.swift
//  Mijn Taken
//
//  Created by Benoit Philips on 09/04/2019.
//  Copyright © 2019 HumbeekWave. All rights reserved.
//

import UIKit
import CoreData

class CDTakenLijst {
    
    var lijst = [Taak]()
    
    let mijnContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func append(_ taakNaam : String, _ taakChecked : Bool){
        let nieuweTaak = Taak(context: mijnContext)
        nieuweTaak.naam = taakNaam
        nieuweTaak.checked = taakChecked
        lijst.append(nieuweTaak)
    }
    
    func append(_ taakNaam : String){
        append(taakNaam, false)
    }
    
    func save (){
         do {
            try mijnContext.save()
        } catch {
            print("BPH: Error saving context \(error)")
        }
    }
    
    func load (){
        let myRequest : NSFetchRequest<Taak> = Taak.fetchRequest()
        do {
            lijst = try mijnContext.fetch(myRequest)
        } catch  {
            print("BPH: Error fetching data (Taak) into mijnContext : \(error)")
        }
    }
}