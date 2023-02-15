//
//  SuperDBNonEditCell.swift
//  SuperDB
//
//  Created by 郑峰 on 2023/2/6.
//

import UIKit

class SuperDBNonEditCell: SuperDBEditCell {

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
        self.textField.isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func isEditable() -> Bool {
        return false
    }
}
