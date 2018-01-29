//
//  StroyboardSupport.swift
//  CardController(卡片转场动画)
//
//  Created by ljb48229 on 2018/1/29.
//  Copyright © 2018年 ljb48229. All rights reserved.
//

import UIKit

/**********Stroyboard 牛逼的使用！！！！！！！！！*************/
protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}
//协议扩展
//在我们的协议扩展声明中，_where_ 子句表示该扩展只适用于 UIViewController 或者它的子类。像 NSDate 这样的类就不会获取到 storyboardIdentifier 协议变量。
//在协议扩展中，我们提供了一个在运行时动态获取 storyboardIdentifier 字符串的方法
extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable {}

extension UIStoryboard {
    
    enum Storyboard: String {
        case main = "Main"
    }
    
    convenience init(storyboard: Storyboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
    class func storyboard(storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Could not find view controller with name \(T.storyboardIdentifier)")
            
        }
        
        return viewController
    }
}
/**********Stroyboard 牛逼的使用！！！！！！！！！*************/


/*****************************/

protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}
extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier)
            else {
                fatalError("Invalid segue identifier: \(String(describing: segue.identifier))")
                
        }
        return segueIdentifier
    }
}






