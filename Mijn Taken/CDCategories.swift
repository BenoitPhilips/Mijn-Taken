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
    
    func load (with request: NSFetchRequest<Category> = Category.fetchRequest()){
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
            let myRequest : NSFetchRequest<Category> = Category.fetchRequest()  //we gebruiken de default request niet
            myRequest.predicate = NSPredicate(format: "naam CONTAINS[cd] %@", CatNaamTeSelecteren)
            myRequest.sortDescriptors = [NSSortDescriptor(key: "naam", ascending: true)]
            load(with: myRequest)
        }
        
    }
}
