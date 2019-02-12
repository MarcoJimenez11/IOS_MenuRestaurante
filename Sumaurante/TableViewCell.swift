//
//  TableViewCell.swift
//  Sumaurante
//
//  Created by mapple on 11/02/2019.
//  Copyright © 2019 mapple. All rights reserved.
//

import UIKit
import SQLite3

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var boton: UIButton!
    var ingredientes: [String?] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func pulsado(_ sender: Any) {
        let plato = boton.currentTitle
        mainInstance.name = plato!
        
        if(boton.backgroundColor == UIColor.white){
            boton.backgroundColor = UIColor.cyan
        }
        else{
            boton.backgroundColor = UIColor.white
        }
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func getDatos(select :String,columna :Int32)->[String]{
        //let queryString = "SELECT * FROM HISTORIAL"
        let queryString = select
        var datos = [String]()
        var stmt:OpaquePointer?
        var db: OpaquePointer?
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Restaurantedb.sqlite")
        
        sqlite3_open(fileURL.path, &db)
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error al preparar select: \(errmsg)")
            return [""]
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            if(sqlite3_column_text(stmt, columna) != nil){
                let nombre = String(cString: sqlite3_column_text(stmt, columna))
                datos.append(nombre)
            }
        }
        
        return datos
    }
}
