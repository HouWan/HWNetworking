//
//  UIFont-Extension.swift
//  SwiftDemo
//
//  Created by HouWan on 2020/5/8.
//  Copyright © 2020 HouWan. All rights reserved.
//

import Foundation

extension UIFont {
    
    /// 快捷创建一个**Medium System Font**，因为UI使用此字体频率非常高
    /// - Parameter fontSize: 字体大小
    /// - Returns: UIFont对象
    public class func mediumFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight:UIFont.Weight.medium)
    }
    
    /// 快捷创建一个**Semibold System Font**，因为UI使用此字体频率非常高
    /// - Parameter fontSize: 字体大小
    /// - Returns: UIFont对象
    public class func semiboldFont(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight:UIFont.Weight.semibold)
    }
}


/// 快捷创建一个**Medium System Font**，因为UI使用此字体频率非常高
/// - Parameter fontSize: fontSize: 字体大小
/// - Returns: UIFont对象
public func MediumFont(_ fontSize: CGFloat) -> UIFont {
    return UIFont.mediumFont(ofSize: fontSize)
}

/// 快捷创建一个**Semibold System Font**，因为UI使用此字体频率非常高
/// - Parameter fontSize: 字体大小
/// - Returns: UIFont对象
public func SemiboldFont(_ fontSize: CGFloat) -> UIFont {
    return UIFont.semiboldFont(ofSize: fontSize)
}

/// 快捷创建一个**System Font**，因为UI使用此字体频率非常高
/// - Parameter fontSize: 字体大小
/// - Returns: UIFont对象
public func SystemFont(_ fontSize: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: fontSize)
}
