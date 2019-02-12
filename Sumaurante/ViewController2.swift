//
//  ViewController2.swift
//  Sumaurante
//
//  Created by mapple on 04/02/2019.
//  Copyright © 2019 mapple. All rights reserved.
//

import UIKit

class ViewController2: UIViewController, UITableViewDataSource {
    
    
    var ingredientes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ingredientes = [String](ingredientes)
    }
    @IBAction func volver(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        
        cell.textLabel?.text=ingredientes[indexPath.row]
        return cell
    }
    
}
