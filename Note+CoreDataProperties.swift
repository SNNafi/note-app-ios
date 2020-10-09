//
//  Note+CoreDataProperties.swift
//  Note App
//
//  Created by Shahriar Nasim Nafi on 9/10/20.
//  Copyright © 2020 Shahriar Nasim Nafi. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String
    @NSManaged public var content: String
    @NSManaged public var priority: Bool

}
