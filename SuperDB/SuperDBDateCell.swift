//
//  SuperDBDateCell.swift
//  SuperDB
//
//  Created by 郑峰 on 2023/2/4.
//

import UIKit

let _dateFormatter = DateFormatter()

class SuperDBDateCell: SuperDBEditCell {
    
    private var datePicker: UIDatePicker!
    
    override var value: AnyObject! {
        get{
            if self.textField.text == nil {
                return nil
            } else {
                return self.datePicker.date as AnyObject
            }
        }
        set{
            if let _value = newValue as? NSDate {
                self.datePicker.date = _value as Date
                self.textField.text = _dateFormatter.string(from: _value as Date)
            } else {
                self.textField.text = nil
            }
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
        
        _dateFormatter.dateStyle = .medium
        self.textField.clearButtonMode = .never
        self.datePicker = UIDatePicker(frame: CGRectZero)
        self.datePicker.datePickerMode = .date
        self.datePicker.addTarget(self, action: #selector(self.datePickerChanged), for: .valueChanged)
        self.textField.inputView = self.datePicker
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func datePickerChanged() {
        let date = self.datePicker.date
        self.value = date as AnyObject
        self.textField.text = _dateFormatter.string(from: date)
    }
    
}
