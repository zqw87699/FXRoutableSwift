//
//  IFXRoutableProtocol.swift
//  TTSwift
//
//  Created by 张大宗 on 2017/5/16.
//  Copyright © 2017年 张大宗. All rights reserved.
//

import Foundation

public protocol IFXRoutableProtocol {
    
    /**
     *  路由视图控制器初始化方法
     *
     *  @param params   参数
     *
     *  @return 视图控制器
     */
    static func initWithUrl(_ URL:String,_ params:Dictionary<String,Any>)->Any
}
