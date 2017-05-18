//
//  FXRouterOption.swift
//  TTSwift
//
//  Created by 张大宗 on 2017/5/16.
//  Copyright © 2017年 张大宗. All rights reserved.
//

import Foundation
import UIKit

public typealias FXRouterOpenCallBack = (_ params: Dictionary<String,Any>)->Void

open class FXRouterOption:NSObject {
    
    var modal = false
    
    var presentationStyle:UIModalPresentationStyle?
    
    var transitionStyle:UIModalTransitionStyle?
    
    var defaultParams:Dictionary<String,Any>?
    
    var navigationControllerClass:UINavigationController.Type?//导航控制器Class（当需要用到时会使用）

    var webViewControllerClass:IFXWebRoutableProtocol.Type?//web试图控制器Class（当需要用到时会使用）

    var openClass:IFXRoutableProtocol.Type?

    var callback:FXRouterOpenCallBack?
    
    public override init() {
        super.init()
    }
    
    public static func routerOptionsWithPresentationStyle(_ presentationStyle:UIModalPresentationStyle,transitionStyle:UIModalTransitionStyle,defaultParams:Dictionary<String,Any>?,isModal:Bool)->FXRouterOption{
        let options = FXRouterOption.init()
        options.presentationStyle = presentationStyle
        options.transitionStyle = transitionStyle
        options.defaultParams = defaultParams
        options.modal = isModal
        options.navigationControllerClass = FXRoutableConfig.sharedInstance.defaultNavigationControllerClass
        options.webViewControllerClass = FXRoutableConfig.sharedInstance.defaultWebViewControllerClass
        return options
    }
    
    public static func routerOptions()->FXRouterOption {
        return self.routerOptionsWithPresentationStyle(UIModalPresentationStyle.none, transitionStyle: UIModalTransitionStyle.coverVertical, defaultParams: nil, isModal: false)
    }
    
    public static func routerOptionsAsModal()->FXRouterOption{
        return self.routerOptionsWithPresentationStyle(UIModalPresentationStyle.none, transitionStyle: UIModalTransitionStyle.coverVertical, defaultParams: nil, isModal: true)
    }
    
    public static func routerOptionsWithPresentationStyle(_ style:UIModalPresentationStyle)->FXRouterOption{
        return self.routerOptionsWithPresentationStyle(style, transitionStyle: UIModalTransitionStyle.coverVertical, defaultParams: nil, isModal: false)
    }
    
    public static func routerOptionsWithTransitionStyle(_ style:UIModalTransitionStyle)->FXRouterOption{
        return self.routerOptionsWithPresentationStyle(UIModalPresentationStyle.none, transitionStyle: style, defaultParams: nil, isModal: false)
    }
    
    public static func routerOptionsForDefaultParams(_ defaultParams:Dictionary<String,Any>)->FXRouterOption{
        return self.routerOptionsWithPresentationStyle(UIModalPresentationStyle.none, transitionStyle: UIModalTransitionStyle.coverVertical, defaultParams: defaultParams, isModal: false)
    }

    
}
