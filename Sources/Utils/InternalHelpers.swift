//
//  InternalHelpers.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/11/13.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation


internal func SubclassOverridesInstanceSelector(superClass: AnyClass, subclass: AnyClass, selector: Selector) -> Bool {
  guard superClass != subclass else {
    // Even if the class implements the selector, it doesn't override itself.
    return false
  }
  
  let superclassMethod = class_getInstanceMethod(superClass, selector)!
  let subclassMethod = class_getInstanceMethod(subclass, selector)!
  return superclassMethod != subclassMethod
  
}
