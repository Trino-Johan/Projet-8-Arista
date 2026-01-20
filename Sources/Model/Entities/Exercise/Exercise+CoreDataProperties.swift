//
//  Exercise+CoreDataProperties.swift
//  Arista
//
//  Created by Johan Trino on 15/01/2026.
//
//

public import Foundation
public import CoreData


public typealias ExerciseCoreDataPropertiesSet = NSSet

extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var category: String?
    @NSManaged public var duration: Int64
    @NSManaged public var intensity: Int64
    @NSManaged public var startDate: Date?
    @NSManaged public var user: User?

}

extension Exercise : Identifiable {

}
