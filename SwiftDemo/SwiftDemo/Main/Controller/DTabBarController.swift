//
//  DTabBarController.swift
//  SwiftDemo
//
//  Created by HouWan on 2020/5/7.
//  Copyright © 2020 HouWan. All rights reserved.
//

import UIKit

/// [Notification key] 双击`TabBar`通知key
let NDoubleTapTabBarNotification = NSNotification.Name("DoubleTapTabBar")


@objcMembers
class DTabBarController: UITabBarController, DTabBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // KVC替换自己的`tabBar`
        let tabBar = DTabBar()
        tabBar.tabBarDelegate = self
        setValue(tabBar, forKeyPath: "tabBar")
        
        // 自定义了`TabBar`，所以下面的title和image参数是没啥用的，这里仅为了记录正常创建ChildVC的方法
        addChild("首页", "tabbar_home", "tabbar_homeH", HomeViewController.self)
        addChild("健身房", "tabbar_gym", "tabbar_gymH", GymViewController.self)
        addChild("光猪圈", "tabbar_coterie", "tabbar_coterieH", SocietyViewController.self)
        addChild("我的", "tabbar_me", "tabbar_meH", MeViewController.self)
    }
    
    
    /// 初始化并添加一个子控制器
    /// - Parameters:
    ///   - title: 标题
    ///   - image: 图标
    ///   - selectedImage: 选中时的图标
    ///   - type: 控制器
    func addChild(_ title: String,
                  _ image: String,
                  _ selectedImage: String,
                  _ type: UIViewController.Type) {
        let vc = DNavigationController(rootViewController: type.init())
        vc.title = title
        vc.tabBarItem.image = UIImage(named: image)
        vc.tabBarItem.selectedImage = UIImage(named: selectedImage)
        vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        addChild(vc)
    }

}


// MARK: - DTabBarDelegate
extension DTabBarController{
    
    /// 单击某个item的代理回调
    /// - Parameters:
    ///   - tabBar: DTabBar对象
    ///   - index: 点击Item的索引
    @objc func singleTap(tabBar:DTabBar, index: Int)  {
        selectedIndex = index
    }
    
    /// 双击某个item的代理回调
    /// - Parameters:
    ///   - tabBar: DTabBar对象
    ///   - index: 点击Item的索引
    @objc func doubleTap(tabBar:DTabBar, index: Int) {
        // 通知刷新数据，eg: 圈子，我的
        NotificationCenter.default.post(name: NDoubleTapTabBarNotification, object: nil)
    }

}
