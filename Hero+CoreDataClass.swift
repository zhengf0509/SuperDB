//
//  Hero+CoreDataClass.swift
//  SuperDB
//
//  Created by 郑峰 on 2023/2/5.
//
//

import Foundation
import CoreData

@objc(Hero)
public class Hero: NSManagedObject {

    var age: Int16? {
        get {
            let gregorian = NSCalendar(calendarIdentifier: .gregorian)
            let components = gregorian?.components(.year, from: self.birthDate!, to: Date())
            let year = components?.year
            return Int16(year!)
        }
    }
}
