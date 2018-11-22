//
//  WeakProxy.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/11/10.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

internal final class WeakProxy<T: AnyObject> {
  
  internal private(set) weak var target: T?
  
  internal init(target: T?) {
    self.target = target
  }
  
}
