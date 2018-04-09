//
//  LayoutElementContext.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/9.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

final class LayoutElementContext {
  
  static let invalidTransitionID = 0
  
  static let defaultTransitionID = 1
  
  static let threadLocalKey = "com.zetasq.SwiftDisplay.LayoutElementContext.threadLocalKey"
  
  let transitionID: Int
  
  private init(transitionID: Int) {
    self.transitionID = transitionID
  }
  
  static func begin() -> LayoutElementContext {
    let context: LayoutElementContext
    if let existingStack = Thread.current.threadDictionary[LayoutElementContext.threadLocalKey] as? NSMutableArray {
      if let existingContext = existingStack.lastObject as? LayoutElementContext {
        context = LayoutElementContext(transitionID: existingContext.transitionID + 1)
      } else {
        context = LayoutElementContext(transitionID: LayoutElementContext.defaultTransitionID)
      }
      existingStack.add(context)
    } else {
      context = LayoutElementContext(transitionID: LayoutElementContext.defaultTransitionID)
      Thread.current.threadDictionary[LayoutElementContext.threadLocalKey] = NSMutableArray(object: context)
    }
    
    return context
  }
  
  static func end() {
    guard let existingStack = Thread.current.threadDictionary[LayoutElementContext.threadLocalKey] as? NSMutableArray,
      existingStack.count > 0 else {
        assert(false, "Existing LayoutElementContext stack is empty on current thread")
        return
    }
    existingStack.removeLastObject()
  }
  
  static func current() -> LayoutElementContext? {
    guard let existingStack = Thread.current.threadDictionary[LayoutElementContext.threadLocalKey] as? NSMutableArray else {
      return nil
    }
    
    return existingStack.lastObject as? LayoutElementContext
  }
  
}
