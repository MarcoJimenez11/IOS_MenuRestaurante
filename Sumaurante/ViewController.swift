//
//  ViewController.swift
//  Sumaurante
//
//  Created by mapple on 01/02/2019.
//  Copyright © 2019 mapple. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController, UITableViewDataSource{
    
    var historial = [String]()
    var db: OpaquePointer?
    var indice = 0
    var data:[String]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Restaurantedb.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        else {
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS RESTAURANTE (plato TEXT, ingrediente TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
    
        insertarDatos()
        data = getDatos(select: "SELECT DISTINCT plato FROM RESTAURANTE",columna: 0)
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        cell.boton.setTitle(data[indexPath.row], for: UIControl.State.normal)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //get the cell based on the indexPath
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        //get the text from a textLabel
       //label.text = cell.boton.currentTitle
    }
    
    func getDatos(select :String,columna :Int32)->[String]{
        //let queryString = "SELECT * FROM HISTORIAL"
        let queryString = select
        var datos = [String]()
        var stmt:OpaquePointer?
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let plato = mainInstance.name
        let ingredientes = getDatos(select: "SELECT ingrediente FROM RESTAURANTE WHERE plato = '"+plato+"'",columna: 0)
        if segue.identifier == "dos" {
            if let viewDos = segue.destination as? ViewController2 {
                viewDos.ingredientes = ingredientes 
            }
        }
    }
    
    func insertarDatos(){
        borrarDatos()
        
        var stmt: OpaquePointer?
        
        let queryString = "INSERT INTO RESTAURANTE ('plato', 'ingrediente') VALUES ('Hamburguesa', 'Carne'),('Hamburguesa', 'Pan'),('Hamburguesa', 'Tomate'),('Hamburguesa', 'Queso'),('Hamburguesa', 'Lechuga'),('Paella', 'Arroz'),('Paella', 'Pollo'),('Paella', 'Almejas'), ('Paella','Gambas'), ('Paella', 'Conejo'),('Tortilla', 'Patatas'),('Tortilla', 'Huevos'),('Tortilla', 'Cebolla'),('Rabo de Toro','Carne'),('Rabo de Toro','Vino tinto'),('Rabo de Toro','Cebolla'),('Rabo de Toro','Zanahoria'),('Rabo de Toro','Ajo'),('Rabo de Toro','Pimienta');"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparando insert: \(errmsg)")
            return
        }
        
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error al insertar: \(errmsg)")
            return
        }
    
    }
    
    func borrarDatos(){
        var stmt: OpaquePointer?
        
        let queryString = "DELETE FROM RESTAURANTE;"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparando insert: \(errmsg)")
            return
        }
        
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error al insertar: \(errmsg)")
            return
        }
        
    }
}

