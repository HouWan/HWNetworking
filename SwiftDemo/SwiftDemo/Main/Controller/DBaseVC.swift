//
//  DBaseVC.swift
//  SwiftDemo
//
//  Created by HouWan on 2020/5/7.
//  Copyright © 2020 HouWan. All rights reserved.
//

import UIKit
import Foundation


/// `DBaseVC`是项目大部分控制器的基类，提供了以下主要功能
/// - `view`的背景色
/// - `deinit`移除`Notification`
public class DBaseVC: UIViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        base_config()
    }
    
    public func base_config() {
        view.backgroundColor = UIColor.white
    }
    
    
    /// 弹框提示，点击[确定]之后`pop`关闭页面, 没有
    /// - Parameter info: 提示信息
    public func popWithInfo(info: String) {
        guard let navVC = navigationController else { return }
        
        navVC.popViewController(animated: true)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

/// For status bar style
extension DBaseVC {
    public override var prefersStatusBarHidden: Bool {
        get { false }
    }
    
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        get { .default }
    }
}
