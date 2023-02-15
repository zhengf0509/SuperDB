//
//  Hero+CoreDataProperties.swift
//  SuperDB
//
//  Created by 郑峰 on 2023/2/5.
//
//

import Foundation
import CoreData
import UIKit

let kHeroValidationDomain = "com.oz.apps.SuperDB.HeroValidationDomain"
let kHeroValidationBirthdateCode = 1000
let kHeroValidationNameOrSecretIdentityCode = 1001


extension Hero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hero> {
        return NSFetchRequest<Hero>(entityName: "Hero")
    }

    @NSManaged public var name: String?
    @NSManaged public var secretIdentity: String?
    @NSManaged public var birthDate: Date?
    @NSManaged public var sex: String?
    @NSManaged public var favoriteColor: UIColor?
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        self.favoriteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        self.birthDate = Date()
    }
    
    /* 单一验证，满足格式
     @objc func validateXXX(_ ioValue: AutoreleasingUnsafeMutablePointer<AnyObject?>) throws 接口格式
    */
    @objc func validateBirthDate(_ ioValue: AutoreleasingUnsafeMutablePointer<AnyObject?>) throws {
        let date = ioValue.pointee as? Date
        if date?.compare(Date()) == .orderedDescending {
            let errorStr = NSLocalizedString("Birthday cannot be in the future", comment: "Birthday cannot be in the future")
            let userInfo = [NSLocalizedDescriptionKey:errorStr]
            
            let outError = NSError(domain: kHeroValidationDomain, code: kHeroValidationBirthdateCode, userInfo: userInfo)
            throw outError
        }
    }
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try self.validateNameOrSecretIdentity()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try self.validateNameOrSecretIdentity()
    }
    
    private func validateNameOrSecretIdentity() throws {
        if self.name!.count > 0 && self.secretIdentity!.count > 0 {
            return
        }
        
        let errorStr = NSLocalizedString("Must provide name and secretIdentity", comment: "Must provide name and secretIdentity")
        let userInfo = [NSLocalizedDescriptionKey:errorStr]
        let outError = NSError(domain: kHeroValidationDomain, code: kHeroValidationNameOrSecretIdentityCode, userInfo: userInfo)
        throw outError
    }

}

extension Hero : Identifiable {

}
