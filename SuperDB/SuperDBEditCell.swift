//
//  SuperDBEditCell.swift
//  SuperDB
//
//  Created by 郑峰 on 2023/2/4.
//

import UIKit

let kLabelTextColor = UIColor(red: 0.321569, green: 0.4, blue: 0.568627, alpha: 1)

class SuperDBEditCell: UITableViewCell {
    
    var label: UILabel!
    var textField: UITextField!
    var key: String!
    
    var value: AnyObject! {
        get{
            return self.textField.text! as AnyObject
        }
        set{
            self.textField.text = newValue as? String
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
        self.contentView.addSubview(self.textField)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.textField.isEnabled = editing
    }
    
}
