//
//  DTabBar.swift
//  SwiftDemo
//
//  Created by HouWan on 2020/5/7.
//  Copyright © 2020 HouWan. All rights reserved.
//
//  https://draveness.me/swift-zhong-init-de-shi-yong/
//  https://www.jianshu.com/p/fb1a91600468
//
//


import UIKit


// MARK: - 点击`DTabBar`事件代理回调
@objc protocol DTabBarDelegate: NSObjectProtocol {
    
    /// 单击某个item的代理回调
    /// - Parameters:
    ///   - tabBar: DTabBar对象
    ///   - index: 点击Item的索引
    @objc func singleTap(tabBar:DTabBar, index: Int) -> Void
    
    /// 双击某个item的代理回调
    /// - Parameters:
    ///   - tabBar: DTabBar对象
    ///   - index: 点击Item的索引
    @objc optional func doubleTap(tabBar:DTabBar, index: Int) -> Void
}



// MARK: - 自定义`UITabBar`
class DTabBar: UITabBar {
    
    /// 当前选中的Item
    fileprivate var currentItem: DTabBar_Item?
    /// 代理
    weak var tabBarDelegate: DTabBarDelegate?
    
    
    ///=============================================================================
    /// - Note: Initialization
    ///=============================================================================
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createAndConfigUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createAndConfigUI()
    }
    
    func createAndConfigUI() {
        isTranslucent = false
        backgroundColor = theme_tint_A_color
        
        let list = [DTabBarItemModel(t: "首页", i: "tabbar_home", s: "tabbar_homeH"),
                    DTabBarItemModel(t: "健身房", i: "tabbar_gym", s: "tabbar_gymH"),
                    DTabBarItemModel(t: "光猪圈", i: "tabbar_coterie", s: "tabbar_coterieH"),
                    DTabBarItemModel(t: "我的", i: "tabbar_me", s: "tabbar_meH")]
        
        let w: CGFloat = CGFloat(ceilf(Float(CGFloat(kScreenWidth / 4.0))))
        
        for (index, data) in list.enumerated() {
            let item = DTabBar_Item(model: data)
            item.frame = CGRect(x: CGFloat(index) * w, y: 0.0, width: w, height: kTabBarHeight)
            addSubview(item)
            
            item.index = index;
            item.selected = index == 0;
            
            if index == 0 { currentItem = item }
            
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTap(tap:)))
            singleTap.numberOfTouchesRequired = 1
            singleTap.numberOfTapsRequired = 1
            item.addGestureRecognizer(singleTap)
            
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap(tap:)))
            doubleTap.numberOfTouchesRequired = 1
            doubleTap.numberOfTapsRequired = 2
            item.addGestureRecognizer(doubleTap)
        }
    }
}

// MARK: - TouchAction
extension DTabBar {
    
    /// 点击
    @objc func singleTap(tap: UITapGestureRecognizer) {
        let item = tap.view as! DTabBar_Item
        guard item != currentItem else { return }
        
        currentItem?.selected = false
        item.selected = true
        currentItem = item
        
        animation(item: item)
        
        guard let d = tabBarDelegate else { return }
        
        if d.responds(to: #selector(d.singleTap(tabBar:index:))) {
            d.singleTap(tabBar: self, index: item.index!)
        }
    }
    
    /// 双击
    @objc func doubleTap(tap: UITapGestureRecognizer) {
        
        let item = tap.view as! DTabBar_Item
        
        // 如果没有正在显示，按单击处理
        guard currentItem == item else {
            singleTap(tap: tap)
            return
        }
        
        guard let d = tabBarDelegate else { return }
        
        if d.responds(to: #selector(d.doubleTap(tabBar:index:))) {
            d.doubleTap?(tabBar: self, index: item.index!)
        }
    }
    
    /// 动画一下
    fileprivate func animation(item: DTabBar_Item) {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulse.duration = 0.2
        pulse.autoreverses = true
        pulse.fromValue = 0.9
        pulse.toValue = 1.1
        item.iconView.layer.add(pulse, forKey: nil)
    }
}


// MARK: - Override
extension DTabBar {
    // -------------------彻底移除系统items-------------------
    override var items: [UITabBarItem]? {
        get { return [] }
        set {}
    }
    
    override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
    }
    // ----------------------------------------------------
}


// MARK: - 自定义`UITabBar`的按钮
fileprivate class DTabBar_Item: UIView {
    
    var model: DTabBarItemModel?
    var index: Int?
    
    /// change UI style
    var selected: Bool = false {
        didSet {
            if selected {
                iconView.image = UIImage(named: model!.selectedImage)
                titleView.textColor = theme_text_A_color
            } else {
                iconView.image = UIImage(named: model!.image)
                titleView.textColor = theme_text_B_color
            }
        }
    }
    
    lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode =  .bottom
        return iconView
    }()
    
    lazy var titleView: UILabel = {
        let titleView = UILabel(font: UIFont.systemFont(ofSize: 10), color: theme_text_A_color, alignment: .center)
        return titleView
    }()
    
    /// 设置Item显示所需数据
    /// - Parameters:
    ///   - model: 数据
    func configData(model: DTabBarItemModel) {
        titleView.text = model.title
        iconView.image = UIImage(named: model.image)
        
        self.model = model
    }
    
    ///=============================================================================
    /// - Note: Initialization
    ///=============================================================================
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createUI()
    }
    
    convenience init(model: DTabBarItemModel) {
        self.init(frame: .zero)
        configData(model: model)
    }
    
    func createUI() {
        backgroundColor = theme_tint_A_color
        addSubview(iconView)
        addSubview(titleView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = CGRect(x: 0, y: 0, width: width, height: 28)
        let y = iconView.bottom + 8
        titleView.frame = CGRect(x: 0, y: y, width: width, height: 12)
    }
}


/// 一个·TabBarItem·展示所需的全部数据
fileprivate struct DTabBarItemModel {
    var title: String
    var image: String
    var selectedImage: String

    /// Initialization
    /// - Parameters:
    ///   - t: title
    ///   - i: image name
    ///   - s: selectedImage name
    init(t: String, i: String, s: String) {
        title = t
        image = i
        selectedImage = s
    }
}
