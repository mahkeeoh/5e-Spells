//
//  Spell.swift
//  5e Spells
//
//  Created by Mikael Olezeski on 2/15/18.
//  Copyright © 2018 Mikael Olezeski. All rights reserved.
//

import Foundation

struct Spell: Codable {
    let name: String
    var desc: String
    var higherLevel: String?
    let page: String?
    let range: String
    let components: String
    let material: String?
    let ritual: String?
    let duration: String
    let concentration: String
    let castingTime: String
    let level: String
    let school: String
    let classes:  String
    let archtype: String?
    let domains: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case desc
        case higherLevel = "higher_level"
        case page
        case range
        case components
        case material
        case ritual
        case duration
        case concentration
        case castingTime = "casting_time"
        case level
        case school
        case classes = "class"
        case archtype
        case domains
    }
}
