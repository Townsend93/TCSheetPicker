//
//  TCSheetStringPicker.swift
//  TCSheetPicker
//
//  Created by tancheng on 2018/8/22.
//  Copyright © 2018年 tancheng. All rights reserved.
//

import Foundation
import UIKit

/*
 目前仅支持的结构,同级(都为2级或3级以上)
        1  a
        2  b
 
 暂不支持,混级(2,3级同时存在)
    1   a
    2   b  ff
    3   c
 
 */


struct TCPickerItem {
    
    let name: String
    let id: String
    
    var children: [TCPickerItem] = []
    
    init(_ data: [String: Any]) {
        
        self.name = "\(data["name"] ?? "")"
        self.id = "\(data["id"] ?? "")"
        
        if data["children"] != nil {
            children = TCPickerItem.array((data["children"] as? [[String: Any]]) ?? [])
        }
    
    }
    
   static func array(_ data: [[String: Any]]) -> [TCPickerItem] {
        return data.map({TCPickerItem($0)})
   }
    
    
}

protocol TCSheetStringPickerDelegate: class {
    func selected(textSet: [String],idSet: [String])
}


final class TCSheetStringPicker: UIView {
    
    ///
    var selectedClosure: (([String],[String])->())?
    
    weak var delegate: TCSheetStringPickerDelegate?
    
    private (set) var items: [TCPickerItem]
    
    private let style: TCPickerStyle
    
    private var backgroundView: UIView!
    
    private var titleView: UIView!
    
    private var picker: UIPickerView!
    
    private var contentView: UIView!
    
    private let title: String
    
    private var selTuple:[Int] = [0]
    
    private var level: Int = 1
    
    ///
    init(
         _ title: String,
         items: [TCPickerItem],
         style: TCPickerStyle = TCPickerStyle()
        )
    {
        self.title = title
        self.items = items
        self.style = style
        
        super.init(frame: UIScreen.main.bounds)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /////
    
    func calculateLevel(_ items:[TCPickerItem]) {
        for item in items {
            if item.children.count > 0 {
                level += 1
                calculateLevel(item.children)
                break
            }
        }
    }
    
    private func setup() {
        
        calculateLevel(items)
        selTuple = Array(repeating: 0, count: level)
        
        backgroundView = UIView(frame: bounds)
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let tap  = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        backgroundView.addGestureRecognizer(tap)
        addSubview(backgroundView)
        
        contentView = UIView(frame: CGRect(
            x: 0,
            y: bounds.height-style.pickerHeight-style.titleViewHeight,
            width: bounds.width,
            height: style.pickerHeight+style.titleViewHeight
        ))
        contentView.backgroundColor = .white
        addSubview(contentView)
        
        titleView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: contentView.bounds.width,
            height: style.titleViewHeight
        ))
        contentView.addSubview(titleView)
    
        let btnWidth: CGFloat = 75
        let margin: CGFloat = 15
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(
            x: margin,
            y: 0,
            width: btnWidth,
            height: titleView.bounds.height
        )
        
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.titleLabel?.font = style.btnFont
        cancelBtn.setTitleColor(style.btnTitleColor, for: .normal)
        cancelBtn.contentHorizontalAlignment = .left
        cancelBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        titleView.addSubview(cancelBtn)
        
        
        let confirmBtn = UIButton(type: .custom)
        confirmBtn.frame = CGRect(
            x: titleView.bounds.width-btnWidth-margin,
            y: 0,
            width: btnWidth,
            height: titleView.bounds.height
        )
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.titleLabel?.font = style.btnFont
        confirmBtn.setTitleColor(style.btnTitleColor, for: .normal)
        confirmBtn.contentHorizontalAlignment = .right
        confirmBtn.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        titleView.addSubview(confirmBtn)
    
        let titleLab = UILabel(frame: CGRect(
            x: cancelBtn.bounds.width + margin,
            y: 0,
            width: titleView.bounds.width-2*(btnWidth+margin),
            height: titleView.bounds.height
        ))
        titleLab.font = style.titleFont
        titleLab.textColor = style.titleColor
        titleLab.textAlignment = .center
        titleLab.text = title
        titleView.addSubview(titleLab)
    
        picker = UIPickerView(frame: CGRect(
            x: 0,
            y: titleView.bounds.height,
            width: contentView.bounds.width,
            height: style.pickerHeight
        ))
        picker.dataSource = self
        picker.delegate = self
        contentView.addSubview(picker)
    
    }
    
    @objc func dismiss() {
        
        UIView.animate(withDuration: 0.23, delay: 0, options: .curveEaseInOut, animations: {
            
            self.contentView.frame.origin.y = self.bounds.height
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
            
        }) { (finished) in
            self.removeFromSuperview()
        }
        
    }
    
    @objc func confirm() {
        var names: [String] = []
        var ids: [String] = []
        
        var startIdx = 1
        
        for (idx,selIdx) in selTuple.enumerated() {
            if idx > 0 {
                
                func getItem(item: TCPickerItem) -> TCPickerItem {
                    
                    if idx == startIdx {
                        return item
                    }
                    let ci = item.children[selTuple[startIdx]]
                    startIdx += 1
                    return getItem(item: ci)
                }
                
                names.append(getItem(item: items[selTuple[0]]).children[selTuple[startIdx]].name)
                ids.append(getItem(item: items[selTuple[0]]).children[selTuple[startIdx]].id)
                
            }else{
                names.append(items[selTuple[0]].name)
                ids.append(items[selTuple[0]].id)
            }
        }
        
        ////
        selectedClosure?(names,ids)
        delegate?.selected(textSet: names, idSet: ids)
        
        dismiss()
    }
    
    func show() {
        
        let originalFrame = contentView.frame
        contentView.frame.origin.y = bounds.height
        let bgColor = backgroundView.backgroundColor
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        let keywindow = UIApplication.shared.keyWindow!
        keywindow.addSubview(self)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            
            self.contentView.frame.origin.y = originalFrame.origin.y
            self.backgroundView.backgroundColor = bgColor
            
        }, completion: nil)
        
        
    }
    
}

extension TCSheetStringPicker: UIPickerViewDataSource,UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return level
    }
    
    func calculateCount(_ component: Int) -> Int {
        
        var startIdx = 1
        
        func getItem(item: TCPickerItem) -> TCPickerItem {
            
            if component == startIdx {
                return item
            }
            let ci = item.children[selTuple[startIdx]]
            startIdx += 1
            return getItem(item: ci)
        }
        
        return getItem(item: items[selTuple[0]]).children.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return items.count
        }
       
        return calculateCount(component)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return style.itemHeight
    }
    
    
    func calculateText(_ component: Int, row: Int) -> String {
        
        var startIdx = 1
        
        func getItem(item: TCPickerItem) -> TCPickerItem {
            
            if component == startIdx {
                return item
            }
            let ci = item.children[selTuple[startIdx]]
            startIdx += 1
            return getItem(item: ci)
        }
        
        return getItem(item: items[selTuple[0]]).children[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let text = component == 0 ? items[row].name : calculateText(component, row: row)
        let attr = NSAttributedString(string: text, attributes: [
                NSAttributedStringKey.font: style.itemFont,
                NSAttributedStringKey.foregroundColor: style.itemColor
            ])
        return attr
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        guard selTuple[component] != row else {
            return
        }
        
        selTuple[component] = row
        
        pickerView.reloadAllComponents()
        
        for (idx,_) in selTuple.enumerated() {
            if idx > component {
                selTuple[idx] = 0
                pickerView.selectRow(0, inComponent: idx, animated: true)
            }
        }
        
        
    }
    
    
}


