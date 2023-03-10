//
//  HeroDetailController.swift
//  SuperDB
//
//  Created by 郑峰 on 2023/2/4.
//

import UIKit
import CoreData

let _dateFormatter = DateFormatter()

class HeroDetailController: UITableViewController {
    
//    var sections: NSArray!
    var config: HeroDetailConfiguration!
    var hero: NSManagedObject?
    
    var saveBtn: UIBarButtonItem?
    var backBtn: UIBarButtonItem?
    var cancelBtn: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // 设置顶端bar
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.saveBtn = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.save))
        self.backBtn = self.navigationItem.leftBarButtonItem
        self.cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        
        // 解析图表plist配置文件
//        let plistURL = Bundle.main.url(forResource: "HeroDetailConfiguration", withExtension: "plist")
//        let plist = NSDictionary(contentsOf: plistURL!)
//        self.sections = plist!.value(forKey: "sections") as? NSArray
        self.config = HeroDetailConfiguration()
        
        self.tableView.register(SuperDBEditCell.self, forCellReuseIdentifier: "HeroDetailCell")
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        self.tableView.beginUpdates()
        self.updateDynamicSections(editing: editing)
        super.setEditing(editing, animated: animated)
        self.tableView.endUpdates()
        
        self.navigationItem.leftBarButtonItem = editing ? self.cancelBtn : self.backBtn
        self.navigationItem.rightBarButtonItem = editing ? self.saveBtn : self.editButtonItem
        
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
//        return self.sections.count
        return self.config.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        let secionDic = self.sections[section] as! NSDictionary
//        let rows = secionDic.object(forKey: "rows") as! NSArray
//        return rows.count
        var rowCount = self.config.numberOfRowsInSection(section)
        if self.config.isDynamicSection(section: section) {
            if let key = self.config.dynamicAttributeKeyForSection(section) {
                let attributeSet = self.hero?.mutableSetValue(forKey: key) as? NSSet
                rowCount = self.isEditing ? attributeSet!.count + 1: attributeSet!.count
            }
        }
        return rowCount
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let sectionDic = self.sections[section] as! NSDictionary
//        return sectionDic.object(forKey: "header") as? String
        return self.config.headerInSecion(section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: SuperDBEditCell

        // Configure the cell...
//        let sectionIndex = indexPath.section
//        let rowIndex = indexPath.row
//        let _sections = self.sections
//        let section = _sections?.object(at: sectionIndex) as? NSDictionary
//        let rows = section?.object(forKey: "rows") as? NSArray
//        let row = rows?.object(at: rowIndex) as? NSDictionary
        
        let row = self.config.rowForIndexPath(indexPath)
//        let cellClassName = row.object(forKey: "class") as! String
        let cellClassName = self.config.cellClassNameForIndexPath(indexPath)
        switch cellClassName {
        case "SuperDBEditCell":
            cell = SuperDBEditCell(style: .value2, reuseIdentifier: cellClassName)
        case "SuperDBDateCell":
            cell = SuperDBDateCell(style: .value2, reuseIdentifier: cellClassName)
        case "SuperDBPickerCell":
            cell = SuperDBPickerCell(style: .value2, reuseIdentifier: cellClassName)
        case "SuperDBNonEditCell":
            cell = SuperDBNonEditCell(style: .value2, reuseIdentifier: cellClassName)
        case "SuperDBColorCell":
            cell = SuperDBColorCell(style: .value2, reuseIdentifier: cellClassName)
        default:
            cell = SuperDBEditCell(style: .value2, reuseIdentifier: cellClassName)
        }
        
        cell.hero = self.hero
//        cell.label?.text = (row.object(forKey: "label") as! String)
        cell.label?.text = self.config.labelForIndexPath(indexPath)
//        let dataKey = row.object(forKey: "key") as! String
        let dataKey = self.config.attributeKeyForIndexPath(indexPath)
        var _text:String? = self.hero?.value(forKey: dataKey) as? String
        if cell.isKind(of: SuperDBDateCell.self), let date = self.hero?.value(forKey: dataKey) as? Date {
            _text = _dateFormatter.string(from: date)
        }
        if cell.isKind(of: SuperDBNonEditCell.self) {
            let _age = (self.hero as? Hero)!.age! as Int16
            _text = String(describing: _age)
        }
        if cell.isKind(of: SuperDBColorCell.self) {
            // 使用特性字符串
            _text = nil;
            let _color:UIColor? = self.hero?.value(forKey: dataKey) as? UIColor
            if _color != nil {
                (cell as! SuperDBColorCell).colorPicker.color = _color!
                let attributedStr:NSAttributedString = (cell as! SuperDBColorCell).attributtedColorString
                cell.textField.attributedText = attributedStr
                cell.textField.attributedPlaceholder = attributedStr
            }
        }
        
        cell.textField?.text = _text
        cell.key = dataKey
        if let _values = row["values"] as? NSArray {
            (cell as! SuperDBPickerCell).values = _values as [AnyObject]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        var editStyle:UITableViewCell.EditingStyle = .none
        let section = indexPath.section
        if self.config.isDynamicSection(section: section) {
            let rowCount = self.tableView.numberOfRows(inSection: section)
            if indexPath.row == rowCount - 1 {
                editStyle = .insert
            } else {
                editStyle = .delete
            }
        }
        return editStyle
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        let
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - private
    @objc func save() {
        for cell in self.tableView.visibleCells {
            var _cell = cell as! SuperDBEditCell
            if !_cell.isEditable() {
                continue
            }
            if _cell.isKind(of: SuperDBDateCell.self) {
                _cell = cell as! SuperDBDateCell
            } else if _cell.isKind(of: SuperDBPickerCell.self) {
                _cell = cell as! SuperDBPickerCell
            } else if _cell.isKind(of: SuperDBColorCell.self) {
                _cell = cell as! SuperDBColorCell
            }
            print("summit key = \(_cell.key), value = \(_cell.value)")
            self.hero?.setValue(_cell.value, forKey: _cell.key)
        }
        
        do {
            try self.hero?.managedObjectContext!.save()
            self.setEditing(false, animated: true)
            self.tableView.reloadData()
        } catch {
            print("Error saving: %@", error)
        }
    }
    
    @objc func cancel() {
        self.setEditing(false, animated: true)
        self.tableView.reloadData()
    }
    
    func updateDynamicSections(editing: Bool) {
        for section in 0..<self.config.numberOfSections() {
            if !self.config.isDynamicSection(section: section) {
                continue;
            }
            var indexPath:IndexPath
            let row = self.tableView.numberOfRows(inSection: section)
            if editing {
                indexPath = IndexPath(row: row, section: section)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            } else {
                indexPath = IndexPath(row: row - 1, section: section)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
        }
    }

}
