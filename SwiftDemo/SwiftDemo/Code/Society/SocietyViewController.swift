//
//  SocietyViewController.swift
//  SwiftDemo
//
//  Created by HouWan on 2020/5/7.
//  Copyright © 2020 HouWan. All rights reserved.
//

import UIKit

class SocietyViewController: DBaseVC, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var page: Int = 1
    
    
    lazy var dataArray: [CoachListModel] = {
        return []
    }()
    
    
    let CELL_CRI = "CellReuseIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "朋友圈"
        
        let h = kScreenHeight - kNavigatioHeight - kTabBarHeight
        let r = CGRect(x: 0, y: kNavigatioHeight, width: kScreenWidth, height: h)
        
        tableView = UITableView(frame: r, style: .plain);
        tableView.backgroundColor = theme_tint_A_color
        tableView.separatorStyle = .none
        tableView.register(SocietyListCell.self, forCellReuseIdentifier: CELL_CRI)
        tableView.delegate = self
        tableView.dataSource = self
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        view.addSubview(tableView)
    }
}

///  UITableViewDelegate
extension SocietyViewController {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    @available(iOS 6.0, *)
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
    }

    @available(iOS 6.0, *)
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("xxx")
    }
}

/// UITableViewDataSource
extension SocietyViewController {
    
    @available(iOS 2.0, *)
    // Default is 1 if not implemented
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = tableView.dequeueReusableCell(withIdentifier: CELL_CRI, for: indexPath) as! SocietyListCell
        c.show(model: dataArray[indexPath.row])
        return c
    }
}

