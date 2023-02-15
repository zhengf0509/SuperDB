//
//  SuperDBColorCell.swift
//  SuperDB
//
//  Created by 郑峰 on 2023/2/6.
//

import UIKit
import CoreData

class SuperDBColorCell: SuperDBEditCell, UIColorPickerDelegate {
    
    var colorPicker: UIColorPicker!
    var attributtedColorString: NSAttributedString! {
        get {
            let block = NSString(utf8String: "\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}\u{2588}")
            let color:UIColor = self.colorPicker.color
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: color
            ]
            
            let attributedString = NSAttributedString(string: block! as String, attributes: attributes)

            return attributedString
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
        self.colorPicker = UIColorPicker(frame: CGRectMake(0, 0, 320, 216))
        self.colorPicker.delegate = self
        self.textField.inputView = self.colorPicker
        self.textField.clearButtonMode = .never
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var value: AnyObject! {
        get {
            return self.colorPicker.color
        }
        set {
            if let _color = newValue as? UIColor {
                self.setValue(aValue: newValue)
                self.colorPicker.color = _color
            } else {
                self.colorPicker.color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            }
//            self.textField.attributedText = self.attributtedColorString
        }
    }
    
    override func setValue(aValue:AnyObject) {
        if let _ = aValue as? UIColor {
//            self.textField.text = _aValue
            self.textField.attributedText = self.attributtedColorString
        } else {
            self.textField.text = aValue.description
        }
    }
    
    // MARK: - UIColorPickerDelegate
    func pickerValueDidChanged() {
        self.value = self.colorPicker.color
    }
}
