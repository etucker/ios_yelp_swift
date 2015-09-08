//
//  UILabel+wrapfix.swift
//
//  Created by Timothy Lee on 9/2/15.
//  Copyright (c) 2015 CodePath, LLC. All rights reserved.
//

import UIKit

extension UILabel {
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        // make sure this isn't a subclass
        if self !== UILabel.self {
            return
        }
        
        dispatch_once(&Static.token) {
            let originalSelector = Selector("layoutSubviews")
            let swizzledSelector = Selector("cp_layoutSubviews")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    }
    
    // MARK: - Method Swizzling
    
    func cp_layoutSubviews() {
        self.cp_layoutSubviews()
        
        preferredMaxLayoutWidth = bounds.size.width
    }
}