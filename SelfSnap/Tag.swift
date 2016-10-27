//
//  Tag.swift
//  SelfSnap
//
//  Created by Alexander Nelson on 10/27/16.
//  Copyright © 2016 JetWolfe Labs. All rights reserved.
//

import Foundation
import CoreData

class Tag: NSManagedObject {
    static let entityName = "\(Tag.self)"

    class func tag(withTitle title: String) -> Tag {
        let tag = NSEntityDescription.insertNewObject(forEntityName: Tag.entityName, into: CoreDataController.sharedInstance.managedObjectContext) as! Tag

        tag.title = title

        return tag
    }
}

extension Tag {
    @NSManaged var title: String
}
