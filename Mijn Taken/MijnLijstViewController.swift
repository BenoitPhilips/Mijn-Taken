//
//  ViewController.swift
//  Mijn Taken
//
//  Created by Benoit Philips on 05/04/2019.
//  Copyright © 2019 HumbeekWave. All rights reserved.
//

import UIKit

class MijnLijstViewController: UITableViewController {

    let TakenLijst = ["Boodschappen 7/11", "Boodschappen Big C", "Bellen naar"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TakenLijst.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaakItemCell", for: indexPath)
        cell.textLabel?.text=TakenLijst[indexPath.row]
        return cell
    }
    
}

