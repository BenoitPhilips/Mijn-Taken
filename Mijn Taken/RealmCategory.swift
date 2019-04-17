//
//  RealmCategory.swift
//  Mijn Taken
//
//  Created by Benoit Philips on 17/04/2019.
//  Copyright © 2019 HumbeekWave. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCategory : Object {
    @objc dynamic var naam: String = ""
    let realmTakenLijst = List<RealmTaak>()
}
