//
//  UIColor.swift
//  DYTV
//
//  Created by idea on 2017/8/7.
//  Copyright © 2017年 idea. All rights reserved.
//

import UIKit

extension UIColor{
    
    //    扩充构造函数，必须扩充便利构造函数，明确的调用 self.init（）
    convenience init(r:CGFloat,g: CGFloat,b:CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
//    返回随机颜色
    class func randomColor() -> UIColor{
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
}
