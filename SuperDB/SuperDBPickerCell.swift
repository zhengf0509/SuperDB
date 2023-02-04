//
//  SuperDBPickerCell.swift
//  SuperDB
//
//  Created by 郑峰 on 2023/2/4.
//

import UIKit

class SuperDBPickerCell: SuperDBEditCell, UIPickerViewDelegate, UIPickerViewDataSource {

    var values:[AnyObject]! = []
    var picker: UIPickerView!
    
    override var value: AnyObject! {
        get{
            return self.textField.text as AnyObject
        }
        
        set{
            if newValue != nil {
                var index = (self.values as NSArray).index(of: newValue as Any)
                if (index != NSNotFound) {
                    self.textField.text = newValue as! String?
                } else {
                    self.textField.text = nil
                }
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
        
        self.textField.clearButtonMode = .never
        
        self.picker = UIPickerView(frame: CGRectZero)
        self.picker.dataSource = self
        self.picker.delegate = self
        self.textField.inputView = self.picker
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.values.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.values[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.value = self.values[row] as! String as AnyObject
    }

}
