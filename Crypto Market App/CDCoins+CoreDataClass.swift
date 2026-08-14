//
//  CDCoins+CoreDataClass.swift
//  Crypto Market App
//
//  Created by Shiddo on 14.08.2026.
//
//

public import Foundation
public import CoreData

@objc(CDCoins)
public class CDCoins: NSManagedObject {
    
    static func fetchAll(context: NSManagedObjectContext) -> [CDCoins] {
        let request: NSFetchRequest<CDCoins> = CDCoins.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка чтения из Core Data: \(error)")
            return []
        }
    }
}
