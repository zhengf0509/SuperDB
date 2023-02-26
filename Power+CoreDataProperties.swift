//
//  Power+CoreDataProperties.swift
//  SuperDB
//
//  Created by 郑峰 on 2023/2/21.
//
//

import Foundation
import CoreData


extension Power {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Power> {
        return NSFetchRequest<Power>(entityName: "Power")
    }

    @NSManaged public var name: String?
    @NSManaged public var source: String?
    @NSManaged public var hero: Hero?

}

extension Power : Identifiable {

}
