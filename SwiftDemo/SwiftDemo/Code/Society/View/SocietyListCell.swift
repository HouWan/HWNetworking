//
//  SocietyListCell.swift
//  SwiftDemo
//
//  Created by HouWan on 2020/5/10.
//  Copyright © 2020 HouWan. All rights reserved.
//

import UIKit
import SnapKit


class SocietyListCell: UITableViewCell {

    lazy var titleView = {
        UILabel(font: MediumFont(15), color: theme_text_B_color)
    }()
    
    func show(model: CoachListModel) {
        titleView.text = model.curriSlogans
    }
    
    
    // ============================================================================
    // MARK: - Initialization
    // ============================================================================
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createAndConfigUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func createAndConfigUI() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor.white
        contentView.isExclusiveTouch = true
        
        contentView.layer.borderColor = UIColor.random.cgColor
        contentView.layer.borderWidth = 0.5
        
        contentView.addSubview(titleView)
        
        
        titleView.snp.makeConstraints { m in
            m.left.equalToSuperview().offset(15)
            m.centerY.equalToSuperview()
        }
        
    }
    
    
}
