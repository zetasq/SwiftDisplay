//
//  ThreadLocal.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/10/29.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

internal enum ThreadLocal<T> {
  
  internal static func value(forKey key: String) -> T? {
    return Thread.current.threadDictionary[key] as? T
  }
  
  internal static func setValue(_ value: T?, forKey key: String) {
    Thread.current.threadDictionary[key] = value
  }
}
