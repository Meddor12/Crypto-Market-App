//
//  CDCoins+CoreDataProperties.swift
//  Crypto Market App
//
//  Created by Shiddo on 14.08.2026.
//
//

public import Foundation
public import CoreData


public typealias CDCoinsCoreDataPropertiesSet = NSSet

extension CDCoins {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCoins> {
        return NSFetchRequest<CDCoins>(entityName: "CDCoins")
    }

    @NSManaged public var id: String?
    @NSManaged public var symbol: String?
    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var price: String?
    @NSManaged public var marketCap: String?
    @NSManaged public var price_change_percentage_24h: String?

}

extension CDCoins : Identifiable {

}
