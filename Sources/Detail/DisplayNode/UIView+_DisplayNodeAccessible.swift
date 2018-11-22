//
//  UIView+_DisplayNodeAccessible.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/11/10.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import UIKit

extension UIView: _DisplayNodeAccessible {
  
  private static var associatedDisplayNodeKey = "associatedDisplayNodeKey"
  
  // Weak reference to avoid cycle, since the node retains the view.
  var displayNode: DisplayNode? {
    get {
      if let proxy = objc_getAssociatedObject(self, &UIView.associatedDisplayNodeKey) as? WeakProxy<DisplayNode> {
        return proxy.target
      } else {
        return nil
      }
    }
    set {
      let proxy = WeakProxy<DisplayNode>(target: newValue)
      objc_setAssociatedObject(self, &UIView.associatedDisplayNodeKey, proxy, .OBJC_ASSOCIATION_RETAIN)
    }
  }
  
}
