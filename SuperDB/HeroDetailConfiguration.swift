//
//  HeroDetailConfiguration.swift
//  SuperDB
//
//  Created by 郑峰 on 2023/2/16.
//

import UIKit

class HeroDetailConfiguration: NSObject {

    var sections: [AnyObject]!
    override init() {
        super.init()
        // 解析图表plist配置文件
        let plistURL = Bundle.main.url(forResource: "HeroDetailConfiguration", withExtension: "plist")
        let plist = NSDictionary(contentsOf: plistURL!)
        self.sections = plist!.value(forKey: "sections") as? [AnyObject]
    }
    
    func numberOfSections() -> Int {
        return self.sections.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        let secionDic = self.sections[section] as! NSDictionary
        if let rows = secionDic.object(forKey: "rows") as? NSArray {
            return rows.count
        }
        return 0
    }
    
    func headerInSecion(_ section: Int) -> String? {
        let sectionDic = self.sections[section] as! NSDictionary
        return sectionDic.object(forKey: "header") as? String
    }
    
    func rowForIndexPath(_ indexPath: IndexPath) -> NSDictionary {
        let sectionIndex = indexPath.section
//        let rowIndex = indexPath.row
        let rowIndex = self.isDynamicSection(section: sectionIndex) ? 0 : indexPath.row
        let section = self.sections![sectionIndex] as! NSDictionary
        let rows = section.object(forKey: "rows") as! NSArray
        let row = rows[rowIndex] as! NSDictionary
        return row
    }
    
    func cellClassNameForIndexPath(_ indexPath: IndexPath) -> String {
        let row = self.rowForIndexPath(indexPath) as NSDictionary
        return row.object(forKey: "class") as! String
    }
    
    func valuesForIndexPath(_ indexPath: IndexPath) -> NSArray {
        let row = self.rowForIndexPath(indexPath) as NSDictionary
        return row.object(forKey: "values") as! NSArray
    }
    
    func attributeKeyForIndexPath(_ indexPath: IndexPath) -> String {
        let row = self.rowForIndexPath(indexPath) as NSDictionary
        return row.object(forKey: "key") as! String
    }
    
    func labelForIndexPath(_ indexPath: IndexPath) -> String {
        let row = self.rowForIndexPath(indexPath) as NSDictionary
        return row.object(forKey: "label") as! String
    }
    
    func isDynamicSection(section: Int) -> Bool {
        var isDynamic = false
        let sectionDic = self.sections[section] as! NSDictionary
        if let dynamicBool = sectionDic.object(forKey: "dynamic") as? Bool {
            isDynamic = dynamicBool
        }
        return isDynamic
    }
    
    func dynamicAttributeKeyForSection(_ section: Int) -> String? {
        if !self.isDynamicSection(section: section) {
            return nil
        }
        let indexPath = IndexPath(row: 0, section: section)
        return self.attributeKeyForIndexPath(indexPath)
    }
}
