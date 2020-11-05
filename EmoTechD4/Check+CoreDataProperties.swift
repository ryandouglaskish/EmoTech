//
//  Check+CoreDataProperties.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 10/21/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//
//

import Foundation
import CoreData


extension Check: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Check> {
        return NSFetchRequest<Check>(entityName: "Check")
    }

    @NSManaged public var checked: Bool
    @NSManaged public var text: String?
    @NSManaged public var id: UUID
    @NSManaged public var timeAdded: Date
    
    var priorityEnum: String? {
        get { text }
        set { text = newValue }
    }
}


