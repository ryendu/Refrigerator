//
//  StorageLocation+CoreDataProperties.swift
//  Refrigerator
//
//  Created by Ryan Du on 5/9/20.
//  Copyright © 2020 Ryan Du. All rights reserved.
//
//

import Foundation
import CoreData


extension StorageLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StorageLocation> {
        return NSFetchRequest<StorageLocation>(entityName: "StorageLocation")
    }

    @NSManaged public var storageName: String?
    @NSManaged public var symbolName: String?
    @NSManaged public var foodItem: NSSet?
    

    public var wrappedStorageName: String {
        storageName ?? "Unkown Storage Name"
    }
    public var wrappedSymbolName: String{
        symbolName ?? "Unkown Symbol Name"
    }
    
    public var foodItemArray: [FoodItem] {
        let set = foodItem?.sortedArray(using: [NSSortDescriptor(keyPath: \FoodItem.name, ascending: true)]) as! [FoodItem]
        return set
    }

}

// MARK: Generated accessors for foodItem
extension StorageLocation {

    @objc(addFoodItemObject:)
    @NSManaged public func addToFoodItem(_ value: FoodItem)

    @objc(removeFoodItemObject:)
    @NSManaged public func removeFromFoodItem(_ value: FoodItem)

    @objc(addFoodItem:)
    @NSManaged public func addToFoodItem(_ values: NSSet)

    @objc(removeFoodItem:)
    @NSManaged public func removeFromFoodItem(_ values: NSSet)

}
