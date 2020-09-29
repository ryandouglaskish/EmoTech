//
//  RecentPick+CoreDataProperties.swift
//  EmoTechD4
//
//  Created by Ryan Kish on 9/10/20.
//  Copyright © 2020 Ryan Kish. All rights reserved.
//
//

import Foundation
import CoreData


extension RecentPick: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentPick> {
        return NSFetchRequest<RecentPick>(entityName: "RecentPick")
    }
    @NSManaged public var emotionName: String
    @NSManaged public var spotify: String
    @NSManaged public var id: UUID
    @NSManaged public var added: Int16
    @NSManaged public var tip: String
    @NSManaged public var mood: String
    @NSManaged public var spotifyLength: String



}
