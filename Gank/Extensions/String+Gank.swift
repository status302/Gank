//
//  String+Gank.swift
//  Gank
//
//  Created by yolo on 2017/3/5.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import UIKit

extension String {
    func boundsWidth(font: UIFont, height: CGFloat) -> CGFloat{
        return self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: height), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: nil).width
    }
    
    func boundsHeight(font: UIFont, width: CGFloat) -> CGFloat {
        return self.boundingRect(with: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: nil).height
    }

    var dateString: String? {
        let formatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
        let formatterToReturn = DateFormatter.init()
        formatterToReturn.dateFormat = "yyyy/MM/dd"
        if let date = formatter.date(from: self) {
            return formatterToReturn.string(from: date)
        }
        return nil
    }
}
