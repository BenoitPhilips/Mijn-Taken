//
//  TakenLijst.swift
//  Mijn Taken
//
//  Created by Benoit Philips on 09/04/2019.
//  Copyright © 2019 HumbeekWave. All rights reserved.
//

import Foundation

class NSTakenLijst {
    
    var lijst = [Taak]()
    
    func append(_ taakNaam : String, _ taakChecked : Bool){
        let nieuweTaak = Taak()
        nieuweTaak.taak = taakNaam
        nieuweTaak.taakChecked = taakChecked
        lijst.append(nieuweTaak)
    }
    
    func append(_ taakNaam : String){
        append(taakNaam, false)
    }
    
    func save (sleutel : String){
         // waar en hoe gaan we onze taken met checkmark gaan saven en kaden
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(sleutel)
        let encoder = PropertyListEncoder()
        
        do {
            let gegevens = try encoder.encode(lijst)
            try gegevens.write(to:dataFilePath!)
        } catch {
            print("error while encoding and writing the data")
        }

    }
    
    func load (sleutel : String){
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(sleutel)
        
        if let gegevens = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                lijst = try decoder.decode([Taak].self, from: gegevens)
            } catch {
                print("Error while loading and decoding the takenLijst")
            }
        } else {
            //not file found, so we start with a default empty takenlijst
        }

    }
}
