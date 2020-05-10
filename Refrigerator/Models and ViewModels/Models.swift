//
//  Models.swift
//  RefrigeratorDesigning(SWIFTUI)
//
//  Created by Ryan Du on 5/1/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//

import Foundation
//TODO: add quantity to the refrige items
//TODO: all of these items below are only temporary and will be replaced by coredata once ui is done
struct refrigeItem:  Identifiable, Hashable {
    var id = UUID()
    var icon: String
    var title: String
    var daysLeft: Int
}

struct shoppingListItems: Identifiable, Hashable {
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
