//
//  FXRoutable.swift
//  TTSwift
//
//  Created by 张大宗 on 2017/5/16.
//  Copyright © 2017年 张大宗. All rights reserved.
//

import Foundation
import UIKit

func fxRoutableAppWindowRootViewController()->UIViewController {
    return (UIApplication.shared.delegate?.window!!.rootViewController)!
}

open class FXRoutable: NSObject {
    
    var routes = Dictionary<String,FXRouterOption>.init()
    
    var returnNodes = Array<UIViewController>.init()
    
    public static let sharedInstance : FXRoutable = FXRoutable()

    override init() {
        super.init()
        do {
            try self.singleInit()
        } catch {
        }
    }
    
    public func singleInit () throws {
        let registerClazz = FXRoutableConfig.sharedInstance.urlRegisterClass
        if registerClazz != nil {
            registerClazz?.routerURLRegister(self)
        }else{
            throw NSException.init(name: NSExceptionName(rawValue: "RoutableInitializerException"), reason: "没有找到 RegisterClass 类型，请在FXRoutableConfig中配置", userInfo: nil) as! Error
        }
    }
    
    /*
     *  注册路由(block)
     */
    public func registe(format:String,toCallback callback:@escaping FXRouterOpenCallBack,wihOptions option:FXRouterOption?){
        var op:FXRouterOption? = option
        if option == nil {
            op = FXRouterOption.routerOptions()
        }
        op?.callback = callback;
        self.routes[format] = op
    }
    
    /*
     *  注册路由
     */
    public func registe(format:String,toController controllerClass:IFXRoutableProtocol.Type,withOptions option:FXRouterOption?){
        var op:FXRouterOption? = option
        if option == nil {
            op = FXRouterOption.routerOptions()
        }
        op?.openClass = controllerClass
        self.routes[format] = op
    }

    /**
     *  设置回退节点
     */
    public func setReturnNode(returnNode:UIViewController){
        if returnNode is IFXRoutableProtocol {
            self.returnNodes.append(returnNode)
        }else{
            print("\(returnNode)未遵守IFXRoutableProtocol协议")
        }
    }

    /**
     *  设置回退根节点
     */
    public func setReturnRootNode(returnRootNode:UIViewController){
        if returnRootNode is IFXRoutableProtocol {
            self.returnNodes.removeAll()
            self.returnNodes.append(returnRootNode)
        }else{
            print("\(returnRootNode)未遵守IFXRoutableProtocol协议")
        }
    }
    
    /**
     *  所有的模态视图控制器
     */
    func allModalControllers()->Array<UIViewController>{
        var presentingViewController = fxRoutableAppWindowRootViewController()
        var presenteds = Array<UIViewController>.init(arrayLiteral: presentingViewController)
        var endTag = true
        while endTag {
            if presentingViewController.presentedViewController != nil {
                presenteds.append(presentingViewController.presentedViewController!)
                presentingViewController = presentingViewController.presentedViewController!;
            }else{
                endTag = false
            }
        }
        return presenteds
    }
    
    /**
     *  打开回退节点
     */
    public func openReturnNode(animated:Bool)->Bool{
        var result = false
        if self.returnNodes.count > 0 {
            if self.returnNodes.last == fxRoutableAppWindowRootViewController() {
                fxRoutableAppWindowRootViewController().dismiss(animated: animated, completion: nil)
                result = true
            }else{
               let allModels = self.allModalControllers()
                for model in allModels {
                    if model is UITabBarController {
                        let selectedVC = (model as! UITabBarController).selectedViewController
                        if selectedVC == self.returnNodes.last {
                            if model.presentedViewController != nil {
                                model.dismiss(animated: animated, completion: nil)
                                result = true
                                break
                            }
                        }else if selectedVC is UINavigationController && (selectedVC?.childViewControllers.contains((self.returnNodes.last)!))! {
                            if model.presentedViewController != nil {
                                model.dismiss(animated: animated, completion: nil)
                            }
                            (selectedVC as! UINavigationController).popToViewController(self.returnNodes.last!, animated: animated)
                            result = true
                            break;
                        }
                    }else if model is UINavigationController {
                        if model.childViewControllers.contains(self.returnNodes.last!) {
                            if model.presentedViewController != nil {
                                model.dismiss(animated: animated, completion: nil)
                            }
                            (model as! UINavigationController).popToViewController(self.returnNodes.last!, animated: animated)
                            result = true
                            break
                        }
                    }else{
                        if model == self.returnNodes.last {
                            if model.presentedViewController != nil {
                                model.dismiss(animated: animated, completion: nil)
                            }
                            result = true
                            break
                        }
                    }
                }
            }
            self.returnNodes.removeLast()
        }
        return result
    }

    /**
     *  打开回退根节点
     */
    public func openReturnRootNode(animated:Bool)->Bool{
        var result = false
        if self.returnNodes.count > 0 {
            if self.returnNodes.first == fxRoutableAppWindowRootViewController() {
                fxRoutableAppWindowRootViewController().dismiss(animated: animated, completion: nil)
                result = true
            }else{
                let allModels = self.allModalControllers()
                for model in allModels {
                    if model is UITabBarController {
                        let selectedVC = (model as! UITabBarController).selectedViewController
                        if selectedVC == self.returnNodes.first {
                            if model.presentedViewController != nil {
                                model.dismiss(animated: animated, completion: nil)
                                result = true
                                break
                            }
                        }else if selectedVC is UINavigationController && (selectedVC?.childViewControllers.contains((self.returnNodes.first)!))! {
                            if model.presentedViewController != nil {
                                model.dismiss(animated: animated, completion: nil)
                            }
                            (selectedVC as! UINavigationController).popToViewController(self.returnNodes.first!, animated: animated)
                            result = true
                            break
                        }
                    }else if model is UINavigationController {
                        if model.childViewControllers.contains(self.returnNodes.first!) {
                            if model.presentedViewController != nil {
                                model.dismiss(animated: animated, completion: nil)
                            }
                            (model as! UINavigationController).popToViewController(self.returnNodes.first!, animated: animated)
                            result = true
                            break
                        }
                    }else{
                        if model == self.returnNodes.first {
                            if model.presentedViewController != nil {
                                model.dismiss(animated: animated, completion: nil)
                            }
                            result = true
                            break
                        }
                    }
                }
            }
            self.returnNodes.removeAll()
        }
        return result
    }

    /**
     *  打开外部url
     */
    public func openExternal(url:String){
        print("打开外部连接\(url)")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL.init(string: url)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL.init(string: url)!)
        }
    }

    /**
     *  打开url
     */
    public func open(url:String,animated:Bool){
        self.open(url: url, animated: animated, extraParams: nil)
    }

    /**
     *  打开url(带参数)
     */
    public func open(url:String,animated:Bool,extraParams:Dictionary<String,Any>?){
        if Thread.isMainThread {
            self.openUrl(url: url, animated: animated, extraParams: extraParams)
        }else{
            weak var selfObject = self
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    if selfObject != nil {
                        selfObject!.openUrl(url: url, animated: animated, extraParams: extraParams)
                    }
                }
            }
        }
    }
    
    /*
     *  打开未注册路由链接
     */
    public func openUnRegisterUrl(url:String,animated:Bool,extraParams:Dictionary<String,Any>?){
        let option = FXRouterOption.routerOptions()
        let controller:UIViewController?
        let webVCClazz = option.webViewControllerClass
        if webVCClazz != nil {
            if webVCClazz!.canOpenURL(url) {
                print("\(String(describing: webVCClazz))可以打开链接:\(url)")
                var mutableExtraParams = Dictionary<String,Any>.init()
                if option.defaultParams != nil && (option.defaultParams?.count)! > 0 {
                    for param in (option.defaultParams?.keys)! {
                        mutableExtraParams[param] = option.defaultParams?[param]
                    }
                }
                if extraParams != nil && (extraParams?.count)! > 0 {
                    for param in (extraParams?.keys)! {
                        mutableExtraParams[param] = extraParams?[param]
                    }
                }
                controller = webVCClazz!.initWithUrl(url, mutableExtraParams) as? UIViewController
                self.openController(controller: controller!, option: option, animated: animated)
            }else{
                print("\(String(describing: webVCClazz))无法打开链接(使用浏览器打开)\(url)")
                self.openExternal(url: url)//使用原始链接打开
                return
            }
        }else{
            print("没有找到WebVC,使用浏览器打开此链接\(url)")
            self.openExternal(url: url)//使用原始链接打开
            return
        }
    }
    
    public func openController(controller:UIViewController,option:FXRouterOption,animated:Bool){
        if option.modal {
            let modals = self.allModalControllers()
            let presentingVC = modals.last
            if controller is UINavigationController {
                presentingVC?.present(controller, animated: animated, completion: nil)
            }else{
                let nav:UINavigationController
                let navClazz = option.navigationControllerClass
                if navClazz != nil {
                    nav = (navClazz?.init(rootViewController: controller))!
                }else{
                    nav = UINavigationController.init(rootViewController: controller)
                }
                print("模态打开视图控制器:\(type(of: controller))")
                presentingVC?.present(nav, animated: animated, completion: nil)
            }
        }else{
            let nav = self.currentNavigationController()
            print("推送打开视图控制器:\(type(of: controller))")
            nav?.pushViewController(controller, animated: animated)
        }
    }
    
    public func openUrl(url:String,animated:Bool,extraParams:Dictionary<String,Any>?){
        print("打开路由链接:\(url)")
        if !self.routes.keys.contains(url) {
            self.openUnRegisterUrl(url: url, animated: animated, extraParams: extraParams)
            return
        }
        
        var option = self.routes[url]
        if option == nil {
            option = FXRouterOption.routerOptions()
        }
        var params = Dictionary<String,Any>.init()
        if option?.defaultParams != nil {
            for key in (option?.defaultParams?.keys)! {
                params[key] = option?.defaultParams?[key]
            }
        }
        if extraParams != nil {
            for key in (extraParams?.keys)! {
                params[key] = extraParams?[key]
            }
        }
        
        if option?.callback != nil {
            let callback = option?.callback
            callback!(params)
            return
        }
        let controller = option?.openClass?.initWithUrl(url, params) as! UIViewController
        controller.modalTransitionStyle = (option?.transitionStyle)!;
        controller.modalPresentationStyle = (option?.presentationStyle)!;

        self.openController(controller: controller, option: option!,animated: animated)
    }
    
    func currentNavigationController()->UINavigationController?{
        var navigationController:UINavigationController?
        let presentings = self.allModalControllers()
        let presentingViewController = presentings.last
        
        if presentingViewController == fxRoutableAppWindowRootViewController() {
            if presentingViewController is UITabBarController {
                let selectedVC = (presentingViewController as! UITabBarController).selectedViewController
                if selectedVC is UINavigationController {
                    navigationController = selectedVC as? UINavigationController
                }
            }
        }
        if navigationController == nil && presentingViewController is UINavigationController {
            navigationController = presentingViewController as? UINavigationController
        }
        return navigationController
    }

    /**
     *  打开root页面
     */
    public func openRoot(rootViewController:UIViewController){
        if Thread.isMainThread {
            fxRoutableAppWindowRootViewController().dismiss(animated: false, completion: nil)
            UIApplication.shared.delegate?.window!?.rootViewController = rootViewController
        }else{
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    fxRoutableAppWindowRootViewController().dismiss(animated: false, completion: nil)
                    UIApplication.shared.delegate?.window!?.rootViewController = rootViewController
                }
            }
        }
    }

    /**
     *  关闭视图控制器（当导航控制器[viewControllers count] == 1时，执行dismiss:completion: 否则执行 pop:）
     *
     *  @param animated 动画
     */
    public func close(animated:Bool){
        if Thread.isMainThread {
            let nav = self.currentNavigationController()
            if nav != nil {
                if (nav?.viewControllers.count)! > 1 {
                    nav?.popViewController(animated: animated)
                }else if nav?.presentingViewController != nil {
                    nav?.dismiss(animated: animated, completion: nil)
                }
            }else if self.allModalControllers().count > 0 {
                self.allModalControllers().last?.dismiss(animated: animated, completion: nil)
            }
        }else{
            weak var selfObject = self
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    if selfObject != nil {
                        let nav = selfObject?.currentNavigationController()
                        if nav != nil {
                            if (nav?.viewControllers.count)! > 1 {
                                nav?.popViewController(animated: animated)
                            }else if nav?.presentingViewController != nil {
                                nav?.dismiss(animated: animated, completion: nil)
                            }
                        }else if (selfObject?.allModalControllers().count)! > 0 {
                            selfObject?.allModalControllers().last?.dismiss(animated: animated, completion: nil)
                        }
                    }
                }
            }
        }
    }

    
    /**
     *  关闭所有视图控制器（当rootViewController有模态视图控制器打开时则关闭模态，否则执行popRoot）
     */
    public func closeAll(animated:Bool){
        if Thread.isMainThread {
            let modals = self.allModalControllers()
            if modals.count > 1 {
                modals.first?.dismiss(animated: animated, completion: nil)
            }else{
                let nav = self.currentNavigationController()
                nav?.popToRootViewController(animated: animated)
            }
        }else{
            weak var selfObject = self
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    if selfObject != nil {
                        let modals = selfObject?.allModalControllers()
                        if (modals?.count)! > 1 {
                            modals?.first?.dismiss(animated: animated, completion: nil)
                        }else{
                            let nav = selfObject?.currentNavigationController()
                            nav?.popToRootViewController(animated: animated)
                        }
                    }
                }
            }
        }
    }
}
