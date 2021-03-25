//
//  ADManager+Pangle.swift
//  PangleAdExample
//
//  Created by my on 2021/3/15.
//

import Foundation
import GeADManager
import PangleAd

extension ADManager {
    
    @discardableResult
    public func requestPangleAd(_ ad: ADCompatble, adDidLoad: ((Any?) -> Void)?, complete: ((Result<Any?, NSError>) -> Void)?) -> TaskCompatible {
        if let _ad = ad as? DefaultADs {
            let defaultFactory = defaultPangleAdTaskFactory(.default, initialFactory: DefaultTaskFactory())
            return defaultFactory.requestAd(_ad, adDidLoad, complete: complete)
        } else if let _ad = ad as? ExpressADs {
            let defaultFactory = defaultPangleAdTaskFactory(.default, initialFactory: ExpressTaskFactory())
            return defaultFactory.requestAd(_ad, adDidLoad, complete: complete)
        } else {
            fatalError("can not support request ad \(ad)")
        }
    }
        
    private func defaultPangleAdTaskFactory<T: TaskFactoryCompatible>(_ category: TaskFactoryCategory, initialFactory: T) -> T {
        if let _defaultTaskFactory = taskFactoryForCategory(category) as? T  {
            return _defaultTaskFactory
        } else {
            register(category, factory: initialFactory)
            return initialFactory
        }
    }
}
