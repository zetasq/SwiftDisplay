//
//  AtomicWeak.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/11/10.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

public final class AtomicWeak<T: AnyObject> {
  
  private let lock = NSLock()
  
  private weak var _val: T?
  
  public var value: T? {
    get {
      return lock.withCriticalScope {
        return _val
      }
    }
    set {
      lock.withCriticalScope {
        _val = newValue
      }
    }
  }
  
  public init(value: T?) {
    self._val = value
  }
  
}
