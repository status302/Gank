//
//  TabbarView.swift
//  Gank
//
//  Created by yolo on 2017/1/22.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit
import SnapKit
import DynamicColor
import Then

protocol TabbarViewDelegate: class {
    func tabbarView(tabbarView: TabbarView, didSeleted item: GankTabbarItem, with index: Int)
}

typealias GankTabbarItem = UIButton

class TabbarView: UIView {
    
    var items: [GankTabbarItem]?
    
    weak var delegate: TabbarViewDelegate?
    
    var stackView: UIStackView!
    var lastSelectedButton: UIButton!
    private var buttons = [UIButton]()

    convenience init() {
        self.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white.darkened()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView().then({
            $0.alignment = .center
            $0.axis = UILayoutConstraintAxis.horizontal
            $0.distribution = UIStackViewDistribution.fillEqually
            self.stackView = $0
        })
        
        addSubview(stackView)
        stackView.snp.makeConstraints({
            $0.edges.equalTo(self)
        })
        for index in 0...3 {
            let button = UIButton(type: .custom).then({
                $0.setTitle("test", for: .normal)
                $0.setTitleColor(UIColor.black, for: .selected)
                $0.setTitleColor(UIColor.black, for: .highlighted)
                $0.setTitleColor(UIColor.gray, for: .normal)
                $0.setTitleColor(UIColor.black, for: .focused)
                $0.tag = index
                $0.addTarget(self, action: #selector(buttonTouchDownSelected(currentButton:)), for: .touchDown)
                $0.addTarget(self, action: #selector(buttonTouchUpInsideSelected(currentButton:)), for: .touchUpInside)
            })
            if index == 0 {
                button.isSelected = true
                button.setTitleColor(UIColor.black, for: .normal)
                lastSelectedButton = button
            }
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    func buttonTouchDownSelected(currentButton: UIButton) {
        guard lastSelectedButton != currentButton else {
            print("refreshing data now")
            return
        }
        lastSelectedButton.isSelected = false
        lastSelectedButton.setTitleColor(UIColor.gray, for: .normal)
    }
    func buttonTouchUpInsideSelected(currentButton: UIButton) {
        currentButton.isSelected = true
        currentButton.setTitleColor(UIColor.black, for: .normal)
        lastSelectedButton = currentButton

        print(currentButton.tag)
    }
    
    func setItems() {
        
    }
    
    func makeContraints() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
