//
//  IFXWebRoutableProtocol.swift
//  TTSwift
//
//  Created by 张大宗 on 2017/5/16.
//  Copyright © 2017年 张大宗. All rights reserved.
//

import Foundation

public protocol IFXWebRoutableProtocol:IFXRoutableProtocol {
    
    /**
     *  是否可以打开此url，如果不能打开则使用浏览器打开
     */
    static func canOpenURL(_ URL:String)->Bool
}
