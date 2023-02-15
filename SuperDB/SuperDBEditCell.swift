//
//  SuperDBEditCell.swift
//  SuperDB
//
//  Created by 郑峰 on 2023/2/4.
//

import UIKit
import CoreData

let kLabelTextColor = UIColor(red: 0.321569, green: 0.4, blue: 0.568627, alpha: 1)

class SuperDBEditCell: UITableViewCell, UITextFieldDelegate {
    
    var label: UILabel!
    var textField: UITextField!
    var key: String!
    
    var hero:NSManagedObject!
    
    var value: AnyObject! {
        get{
            return self.textField.text! as AnyObject
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.label = UILabel(frame: CGRectMake(12, 15, 67, 15))
        self.label.backgroundColor = UIColor.clear
        self.label.font = UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize)
        self.label.textColor = kLabelTextColor
        self.label.text = "label"
        self.contentView.addSubview(self.label)
        
        self.textField = UITextField(frame: CGRectMake(93, 13, 170, 19))
        self.textField.backgroundColor = UIColor.clear
        self.textField.clearButtonMode = .whileEditing
        self.textField.isEnabled = false
        self.textField.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        self.textField.text = "Title"
        self.textField.delegate = self
        self.contentView.addSubview(self.textField)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func isEditable() -> Bool {
        return true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.textField.isEnabled = editing && self.isEditable()
    }
    
    func validate() {
        var val = self.value
        do {
            try self.hero.validateValue(&val, forKey: self.key)
        } catch {
            var message: String!
            let nserror = error as NSError
            if nserror.domain == NSCocoaErrorDomain {
                let userInfo = nserror.userInfo
                let errorKey = userInfo[NSValidationObjectErrorKey]
                let reason = nserror.localizedFailureReason
                message = NSLocalizedString("Validation error on \(String(describing: errorKey))\rFailure Reason:\(String(describing: reason))", comment:" Validation error on \(String(describing: errorKey))\rFailure Reason:\(String(describing: reason))")
            } else {
                message = nserror.localizedDescription
            }

            let title = NSLocalizedString("Validation Error", comment: "Validation Error")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let fixAction = UIAlertAction(title: "Fix", style: .default) { _ in
                self.textField.becomeFirstResponder()
            }
            alert.addAction(fixAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.setValue(aValue: self.hero.value(forKey: self.key) as AnyObject)
            }
            alert.addAction(cancelAction)

            // TODO: 这个弹窗有概率crash
            let superVC = self.viewControllerOf(view: self)
            superVC!.present(alert, animated: true)
        }
    }
    
    func viewControllerOf(view: UIView) -> UIViewController? {
        var responser:UIResponder? = view as UIResponder
        repeat {
            responser = responser?.next ?? nil
            let result = responser?.isKind(of: UIViewController.self)
            if result! {
                let vc = responser as! UIViewController
                return vc
            }
        }while(responser != nil)
        
        return nil
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.validate()
    }
    
    func setValue(aValue:AnyObject) {
        if let _aValue = aValue as? String {
            self.textField.text = _aValue
        } else {
            self.textField.text = aValue.description
        }
    }
}
