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
    var baseFilter = NSPredicate()
    var gekozenCat : Category? {
        didSet {
            baseFilter = NSPredicate(format: "pCategory MATCHES %@", gekozenCat!.naam!)
            load()
        }
    }

    let mijnContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func append(_ taakNaam : String, _ taakChecked : Bool){
        let nieuweTaak = Taak(context: mijnContext)
        nieuweTaak.naam = taakNaam
        nieuweTaak.checked = taakChecked
        nieuweTaak.pCategory = gekozenCat
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
    
    func load (with request: NSFetchRequest<Taak> = Taak.fetchRequest(),filteredBy extraFilter: NSPredicate? = nil){
        if extraFilter != nil {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [baseFilter,extraFilter!])
        } else {
            request.predicate = baseFilter
        }
//        request.predicate = NSPredicate(format: "pCategory MATCHES %@", gekozenCat!.naam!)
        request.sortDescriptors = [NSSortDescriptor(key: "naam", ascending: true)]
        do {
            lijst = try mijnContext.fetch(request)
        } catch  {
            print("BPH: Error fetching data (Taak) into myContext : \(error)")
        }
    }
    
     func load (_ taakNaamTeSelecteren : String){
        if taakNaamTeSelecteren == "" {
            load()
        } else {
            let extraFilter = NSPredicate(format: "naam CONTAINS[cd] %@", taakNaamTeSelecteren)
            load(filteredBy: extraFilter)
         }

    }
}
