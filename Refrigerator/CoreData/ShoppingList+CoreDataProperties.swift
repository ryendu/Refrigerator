//
//  ShoppingList+CoreDataProperties.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/23/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//
//

import Foundation
import CoreData


extension ShoppingList : Identifiable{

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingList> {
        return NSFetchRequest<ShoppingList>(entityName: "ShoppingList")
    }

    @NSManaged public var name: String?
    @NSManaged public var icon: String?
    @NSManaged public var checked: Bool
    
    public var wrappedName: String {
        name ?? "unkown name"
    }
    public var wrappedIcon: String {
        icon ?? "⍰"
    }
}
