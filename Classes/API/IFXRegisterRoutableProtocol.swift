//
//  IFXRegisterRoutableProtocol.swift
//  TTSwift
//
//  Created by 张大宗 on 2017/5/16.
//  Copyright © 2017年 张大宗. All rights reserved.
//

import Foundation

public protocol IFXRegisterRoutableProtocol {
    /**
     *  注册URL
     */
    static func routerURLRegister(_ routable:FXRoutable);
}
