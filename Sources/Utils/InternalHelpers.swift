//
//  InternalHelpers.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/8.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import UIKit

internal let MAIN_SCREEN_SCALE: CGFloat = {
  UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0)
  defer {
    UIGraphicsEndImageContext()
  }
  
  return UIGraphicsGetCurrentContext()!.ctm.a
}()


extension CGFloat {
  
  var floorPixelValue: CGFloat {
    let scale = MAIN_SCREEN_SCALE
    return floor(self * scale) / scale
  }
  
  var ceilPixelValue: CGFloat {
    let scale = MAIN_SCREEN_SCALE
    return ceil(self * scale) / scale
  }

  var roundPixelValue: CGFloat {
    let scale = MAIN_SCREEN_SCALE
    return (self * scale).rounded() / scale
  }
  
}

extension CGPoint {
  
  var floorPixelValue: CGPoint {
    return CGPoint(x: self.x.floorPixelValue, y: self.y.floorPixelValue)
  }
  
  var ceilPixelValue: CGPoint {
    return CGPoint(x: self.x.ceilPixelValue, y: self.y.ceilPixelValue)
  }
  
  var roundPixelValue: CGPoint {
    return CGPoint(x: self.x.roundPixelValue, y: self.y.roundPixelValue)
  }
  
}

extension CGSize {
  
  var floorPixelValue: CGSize {
    return CGSize(width: self.width.floorPixelValue, height: self.height.floorPixelValue)
  }
  
  var ceilPixelValue: CGSize {
    return CGSize(width: self.width.ceilPixelValue, height: self.height.ceilPixelValue)
  }
  
  var roundPixelValue: CGSize {
    return CGSize(width: self.width.roundPixelValue, height: self.height.roundPixelValue)
  }
  
}

internal func SubclassOverridesInstanceSelector(superClass: AnyClass, subclass: AnyClass, selector: Selector) -> Bool {
  guard superClass != subclass else {
    // Even if the class implements the selector, it doesn't override itself.
    return false
  }
  let superclassMethod = class_getInstanceMethod(superClass, selector)!
  let subclassMethod = class_getInstanceMethod(subclass, selector)!
  return superclassMethod != subclassMethod
}
