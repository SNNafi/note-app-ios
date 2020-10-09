//
//  Note+CoreDataClass.swift
//  Note App
//
//  Created by Shahriar Nasim Nafi on 9/10/20.
//  Copyright © 2020 Shahriar Nasim Nafi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {
    
    class func generateNoteId() -> Int32 {
        let userDefaults = UserDefaults.standard
        let itemId = userDefaults.integer(forKey: "NoteID")
        userDefaults.set(itemId + 1, forKey: "NoteID")
        userDefaults.synchronize()
        return Int32(itemId)
        
    }

}
