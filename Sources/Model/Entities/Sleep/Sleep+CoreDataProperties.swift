//
//  Sleep+CoreDataProperties.swift
//  Arista
//
//  Created by Johan Trino on 15/01/2026.
//
//

public import Foundation
public import CoreData


public typealias SleepCoreDataPropertiesSet = NSSet

extension Sleep {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sleep> {
        return NSFetchRequest<Sleep>(entityName: "Sleep")
    }

    @NSManaged public var duration: Int64
    @NSManaged public var quality: Int64
    @NSManaged public var startDate: Date?
    @NSManaged public var user: User?

}

extension Sleep : Identifiable {

}
