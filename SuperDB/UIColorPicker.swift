//
//  UIColorPicker.swift
//  SuperDB
//
//  Created by 郑峰 on 2023/2/6.
//

import UIKit
import QuartzCore

let kTopBackgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
let kBottomBackgroundColor = UIColor(red: 0.79, green: 0.79, blue: 0.79, alpha: 1)

@objc protocol UIColorPickerDelegate {
    @objc optional func pickerValueDidChanged()
}

class UIColorPicker: UIControl {

    var _color: UIColor! = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    
    private var _redSlider: UISlider!
    private var _greenSlider: UISlider!
    private var _blueSlider: UISlider!
    private var _alphaSlider: UISlider!
    
    weak var delegate: UIColorPickerDelegate?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        labelWithFrame(frame: CGRectMake(20, 40, 60, 24), text: "Red")
        labelWithFrame(frame: CGRectMake(20, 80, 60, 24), text: "Grenn")
        labelWithFrame(frame: CGRectMake(20, 120, 60, 24), text: "Black")
        labelWithFrame(frame: CGRectMake(20, 160, 60, 24), text: "Alpha")
        
        let _sel = #selector(self.slideChanged(sender:))
        self._redSlider = createSliderWithAction(frame: CGRectMake(100, 40, 190, 24), sel: _sel)
        self._greenSlider = createSliderWithAction(frame: CGRectMake(100, 80, 190, 24), sel: _sel)
        self._blueSlider = createSliderWithAction(frame: CGRectMake(100, 120, 190, 24), sel: _sel)
        self._alphaSlider = createSliderWithAction(frame: CGRectMake(100, 160, 190, 24), sel: _sel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func labelWithFrame(frame: CGRect, text: String) {
        let label = UILabel(frame: frame)
        label.isUserInteractionEnabled = false
        label.backgroundColor = UIColor.clear
        label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        label.textAlignment = .right
        label.textColor = UIColor.darkText
        label.text = text
        self.addSubview(label)
    }
    
    override func draw(_ rect: CGRect) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [kTopBackgroundColor.cgColor,
                           kBottomBackgroundColor.cgColor]
        self.layer.insertSublayer(gradient, at: 0)
        
    }
    
    @objc func slideChanged(sender: AnyObject) {
        color = UIColor(red: CGFloat(_redSlider.value), green: CGFloat(_greenSlider.value), blue: CGFloat(_blueSlider.value), alpha: CGFloat(_alphaSlider.value))
        
        if let _delegate = self.delegate {
            _delegate.pickerValueDidChanged?()
        }
    }
    
    func createSliderWithAction(frame: CGRect, sel: Selector) -> UISlider {
        let _slider = UISlider(frame: frame)
        _slider.addTarget(self, action: sel, for: .valueChanged)
        self.addSubview(_slider)
        return _slider
    }
    
    var color:UIColor {
        get {
            return _color
        }
        set {
            _color = newValue
            let components = _color.cgColor.components
            _redSlider.setValue(Float(components![0]), animated: true)
            _greenSlider.setValue(Float(components![1]), animated: true)
            _blueSlider.setValue(Float(components![2]), animated: true)
            _alphaSlider.setValue(Float(components![3]), animated: true)
        }
    }
    
}
