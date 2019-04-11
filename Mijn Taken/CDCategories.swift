//
//  Categorieën.swift
//  Mijn Taken
//
//  Created by Benoit Philips on 09/04/2019.
//  Copyright © 2019 HumbeekWave. All rights reserved.
//

import UIKit
import CoreData

class CDCategoriesLijst {
    
    var lijst = [Category]()
    
    let mijnContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    // Waar is de SQLLite database gestockeerd ?
    // opgelet, niet in .documentsDirectory maar in Library/Application Support van onze applicatie
    let mijnDB = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
    
    func append(_ CatNaam : String){
        let nieuweCat = Category(context: mijnContext)
        nieuweCat.naam = CatNaam
         lijst.append(nieuweCat)
    }
    
     func save (){
        do {
            try mijnContext.save()
        } catch {
            print("BPH: Error saving context \(error)")
        }
    }
    
    func load (with request: NSFetchRequest<Category> = Category.fetchRequest(),filteredBy extraFilter: NSPredicate? = nil){
        if extraFilter != nil {
            request.predicate = extraFilter
        }
        request.sortDescriptors = [NSSortDescriptor(key: "naam", ascending: true)]
        do {
            lijst = try mijnContext.fetch(request)
        } catch  {
            print("BPH: Error fetching data (Categorie) into myContext : \(error)")
        }
    }
    
    func load (_ CatNaamTeSelecteren : String){
        if CatNaamTeSelecteren == "" {
            load()
        } else {
            let predicate = NSPredicate(format: "naam CONTAINS[cd] %@", CatNaamTeSelecteren)
            load(filteredBy: predicate)
        }
        
    }
}
