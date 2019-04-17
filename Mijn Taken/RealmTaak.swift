//
//  RealmItem.swift
//  Mijn Taken
//
//  Created by Benoit Philips on 17/04/2019.
//  Copyright © 2019 HumbeekWave. All rights reserved.
//

import Foundation
import RealmSwift

class RealmTaak : Object {
    @objc dynamic var naam : String = ""
    @objc dynamic var checked : Bool = false
    let realmParentCategory = LinkingObjects(fromType: RealmCategory.self, property: "realmTakenLijst")
}
