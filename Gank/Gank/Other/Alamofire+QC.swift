//
//  Alamofire+QC.swift
//  Gank
//
//  Created by 程庆春 on 16/5/23.
//  Copyright © 2016年 qiuncheng.com. All rights reserved.
//

import Foundation
import Alamofire// -> [[String: String?]]

func alamofireGetData(url: String){

    let request = Alamofire.request(.GET, url, parameters: nil, encoding: ParameterEncoding.JSON, headers: nil)

    request.responseJSON { (response) in

        print("\(response.result)")
    }

//    return response.result["results"] as [[String: String?]]
}
