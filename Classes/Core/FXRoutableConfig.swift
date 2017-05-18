//
//  FXRoutableConfig.swift
//  TTSwift
//
//  Created by 张大宗 on 2017/5/16.
//  Copyright © 2017年 张大宗. All rights reserved.
//

import Foundation
import UIKit

open class FXRoutableConfig: NSObject {
    
    open var defaultWebViewControllerClass:IFXWebRoutableProtocol.Type?
    
    /**
     *  默认导航视图控制器
     *  Default UINavigationController
     */
    open var defaultNavigationControllerClass:UINavigationController.Type?
    
    open var urlRegisterClass:IFXRegisterRoutableProtocol.Type?
    
    override init() {
        super.init()
    }
    
    public static let sharedInstance = FXRoutableConfig()
    
    open func setWebViewControllerClass(_ webViewControllerClass:IFXWebRoutableProtocol.Type){
        self.defaultWebViewControllerClass = webViewControllerClass
    }
    
    open func setNavigationControllerClass(_ navigationControllerClass:UINavigationController.Type){
        self.defaultNavigationControllerClass = navigationControllerClass;
    }
   
    open func setRegisterClass(_ urlRegisterClass:IFXRegisterRoutableProtocol.Type){
        self.urlRegisterClass = urlRegisterClass;
    }
}
