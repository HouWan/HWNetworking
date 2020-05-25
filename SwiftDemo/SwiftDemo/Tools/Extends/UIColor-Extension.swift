//
//  UIColor-Extension.swift
//  SwiftDemo
//
//  Created by HouWan on 2020/5/7.
//  Copyright © 2020 HouWan. All rights reserved.
//

import Foundation

// MARK: - Initializers
extension UIColor {
    
    /// 快捷构造器-RGBA色值，RGB取值范围是[0...255], alpha取值范围是[0...1]
    /// - Author: HouWan
    /// - Parameters:
    ///   - r: red
    ///   - g: green
    ///   - b: blue
    ///   - a: alpha, default: 1.0
    convenience public init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue:b/255.0, alpha:a)
    }
    
    /// Same as above!
    convenience public init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1.0) {
        self.init(red: r/255.0, green: g/255.0, blue:b/255.0, alpha:a)
    }
    
    /// 使用十六进制颜色码生成`UIColor`对象, eg:`UIColor(0xFF2D3A)`
    /// - Author: HouWan
    /// - Parameters:
    ///   - hexValue: 十六进制数值
    ///   - alpha: alpha, default: 1.0, alpha取值范围是[0...1]
    convenience public init(_ hexValue: Int, alpha: Float = 1.0) {
        self.init(red: CGFloat((hexValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((hexValue & 0x00FF00) >> 8) / 255.0,
                 blue: CGFloat(hexValue & 0x0000FF) / 255.0,
                alpha: CGFloat(alpha))
    }
    
    /// 使用十六进制颜色码生成`UIColor`对象, eg:`UIColor.hexColor(0xFF2D3A)`
    /// - Author: HouWan
    /// - Parameters:
    ///   - hexValue: 十六进制数值
    ///   - alpha: alpha, default: 1.0, alpha取值范围是[0...1]
    /// - Returns: 十六进制颜色
    class func hexColor(_ hexValue: Int, alpha: Float = 1.0) -> UIColor {
        return UIColor(hexValue, alpha: alpha)
    }

}


// MARK: - Properties
extension UIColor {
    
    /// 返回一个随机得出来的RGB颜色, 透明度为1.0
    class var random: UIColor {
        let red = CGFloat(Int.random(in: 0...255))
        let green = CGFloat(Int.random(in: 0...255))
        let blue = CGFloat(Int.random(in: 0...255))
        return UIColor.init(red, green, blue)
    }
}
