//
//  WelfareCollectionViewCell.swift
//  Gank
//
//  Created by 程庆春 on 16/5/24.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import UIKit

class WelfareCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var meiziImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var alphaView: UIView!


    override func awakeFromNib() {
        super.awakeFromNib()

        descriptionLabel.textColor = UIColor.whiteColor()
        descriptionLabel.font = UIFont.font_dfphaib(size: 12) //UIFont(name: "DFPHaiBaoW12-GB", size: 12)
    }
    var result: Result! {
        didSet {
            meiziImageView.kf_setImageWithURL(NSURL(string: result.url)!)
            descriptionLabel.text = "#" + result.desc
        }
    }
    var welfareResult: SortResult! {
        didSet {
            meiziImageView.kf_setImageWithURL(NSURL(string: welfareResult.url!)!)
            descriptionLabel.text = "#" + welfareResult.desc!

        }
    }
    // MARK: - lazy
    lazy var welfareViewCell: WelfareCollectionViewCell = {
        let welfareViewCell = NSBundle.mainBundle().loadNibNamed("WelfareCollectionViewCell", owner: nil, options: nil).first as! WelfareCollectionViewCell
        return welfareViewCell
    }()

    var manImageURLs = ["http://7xk67j.com1.z0.glb.clouddn.com/images%20%281%29.jpeg", "http://7xk67j.com1.z0.glb.clouddn.com/images.jpeg", "http://7xk67j.com1.z0.glb.clouddn.com/Daniel-Wu-2.jpg", "http://7xk67j.com1.z0.glb.clouddn.com/Daniel-Wu-Whos-Dated-Who.jpg"]
    
}
