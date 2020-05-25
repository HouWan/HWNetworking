//
//  UILabel-Extension.swift
//  SwiftDemo
//
//  Created by HouWan on 2020/5/8.
//  Copyright © 2020 HouWan. All rights reserved.
//

import Foundation

extension UILabel {
    
    /// 快速创建一个`UILabel`，使用`font & textColor | alignment`
    /// - Author: HouWan
    /// - Parameters:
    ///   - font: UIFont对象
    ///   - color: 字体颜色
    ///   - alignment: The default was NSTextAlignmentLeft
    convenience public init(font: UIFont, color: UIColor, alignment: NSTextAlignment = .left) {
        self.init()
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
    }
    
    
    
}
 
