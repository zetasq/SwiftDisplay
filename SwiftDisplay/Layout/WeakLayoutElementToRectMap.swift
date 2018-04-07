//
//  WeakDictionary.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 8/4/2018.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

struct WeakLayoutElementToRectMap {
  
  private var _storage: [WeakKey: CGRect] = [:]
  
  init() {}
  
  subscript(_ key: LayoutElement) -> CGRect? {
    get {
      return _storage[WeakKey(key: key)]
    }
    set {
      let weakKey = WeakKey(key: key)
      _storage[weakKey] = nil // incase we have a niled key
      _storage[weakKey] = newValue
    }
  }

}

extension WeakLayoutElementToRectMap {
  struct WeakKey: Hashable {
    
    let hashValue: Int
    
    static func == (lhs: WeakKey, rhs: WeakKey) -> Bool {
      guard let key1 = lhs.key, let key2 = rhs.key else {
        return false
      }
      return key1 === key2
    }
    
    private(set) weak var key: LayoutElement?
    
    init(key: LayoutElement) {
      self.hashValue = ObjectIdentifier(key).hashValue
      self.key = key
    }
  }
}
