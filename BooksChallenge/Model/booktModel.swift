//
//  bookModel.swift
//  Books
//
//  Created by Jésica González Baqué on 08/06/2021.
//

import Foundation

// Estructura para cargar los valores que vienen en el JSON

// Cada producto
struct Book: Codable
{
    var id:Int
    var nombre:String
    var autor:String
    var disponibilidad:Bool
    var popularidad:Int
    var imagen:String
    
}

// El arrego de productos
struct Books: Codable {
    var results: [Book]
}


