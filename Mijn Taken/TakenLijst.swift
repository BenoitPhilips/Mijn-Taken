//
//  TakenLijst.swift
//  Mijn Taken
//
//  Created by Benoit Philips on 09/04/2019.
//  Copyright © 2019 HumbeekWave. All rights reserved.
//

import Foundation

class TakenLijst {
    
    var lijst = [Taak]()
    
    var lijstDefaults = UserDefaults.standard
    
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
        var lijstS : [String] = []
        var lijstB : [Bool] = []
        
        for positie in 0..<lijst.count {
            lijstS.append(lijst[positie].taak)
            lijstB.append(lijst[positie].taakChecked)
        }
        lijstDefaults.set(lijstS, forKey: sleutel+"S")
        lijstDefaults.set(lijstB, forKey: sleutel+"B")
    }
    
    func load (sleutel : String){
        var lijstS : [String] = []
        var lijstB : [Bool] = []

        if let lijstSt = lijstDefaults.array(forKey: sleutel+"S") {
            lijstS = lijstSt as! [String]
            if let lijstBt = lijstDefaults.array(forKey: sleutel+"B") {
                lijstB = lijstBt as! [Bool]
                if lijstS.count == lijstB.count {
                    for positie in 0..<lijstS.count {
                        append(lijstS[positie], lijstB[positie])
                    }
                } else {
                    //size of lijstS different of lijst B : solve by set all to false
                    for positie in 0..<lijstS.count {
                        append(lijstS[positie])
                    }
               }
            } else {
                //String array found without Bool array : solve by set to all to false.
                for positie in 0..<lijstS.count {
                    append(lijstS[positie])
                }
            }

        } else {
            //no saved lijstS found : solve by starting with empty takenlijst
        }
    }
}
