//
//  Models.swift
//  RefrigeratorDesigning(SWIFTUI)
//
//  Created by Ryan Du on 5/1/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import Foundation
struct refrigeItem:  Identifiable, Hashable {
    var id = UUID()
    var icon: String
    var title: String
    var daysLeft: Int
    var addToStorage: StorageLocation
}

struct shoppingListItems: Identifiable, Hashable, Codable {
    var id = UUID()
    var icon: String
    var title: String
}

struct storageLocationItems: Identifiable, Hashable {
    var id = UUID()
    var icon: String
    var title: String
    var numberOfItems: Int
}
