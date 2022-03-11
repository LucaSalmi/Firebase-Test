//
//  Item.swift
//  Firebase Test
//
//  Created by Luca Salmi on 2022-03-11.
//

import Foundation
import FirebaseFirestoreSwift

struct Item : Codable, Identifiable{
    
    @DocumentID var id: String?
    var name: String
    var done: Bool = false
    var category: String = ""
    
}
