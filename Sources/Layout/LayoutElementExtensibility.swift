//
//  LayoutElementExtensibility.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/7.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import UIKit

protocol LayoutElementExtensibility {
  
  // The maximum number of extended values per type are defined in ASEnvironment.h above the ASEnvironmentStateExtensions
  // struct definition. If you try to set a value at an index after the maximum it will throw an assertion.

  func setLayoutOptionExtensionBool(_ value: Bool, atIndex index: Int)
  
  func layoutOptionExtensionBool(atIndex index: Int) -> Bool
  
  func setLayoutOptionExtensionInteger(_ value: Int, atIndex index: Int)
  
  func layoutOptionExtensionInteger(atIndex index: Int) -> Int
  
  func setLayoutOptionExtensionEdgeInsets(_ value: UIEdgeInsets, atIndex index: Int)
  
  func layoutOptionExtensionEdgeInsets(atIndex index: Int) -> UIEdgeInsets
  
}

extension LayoutElementExtensibility where Self: LayoutElement {
  
  func setLayoutOptionExtensionBool(_ value: Bool, atIndex index: Int) {
    self.style.setLayoutOptionExtensionBool(value, atIndex: index)
  }
  
  func layoutOptionExtensionBool(atIndex index: Int) -> Bool {
    return self.style.layoutOptionExtensionBool(atIndex: index)
  }
  
  func setLayoutOptionExtensionInteger(_ value: Int, atIndex index: Int) {
    self.style.setLayoutOptionExtensionInteger(value, atIndex: index)
  }
  
  func layoutOptionExtensionInteger(atIndex index: Int) -> Int {
    return self.style.layoutOptionExtensionInteger(atIndex: index)
  }
  
  func setLayoutOptionExtensionEdgeInsets(_ value: UIEdgeInsets, atIndex index: Int) {
    self.style.setLayoutOptionExtensionEdgeInsets(value, atIndex: index)
  }
  
  func layoutOptionExtensionEdgeInsets(atIndex index: Int) -> UIEdgeInsets {
    return self.style.layoutOptionExtensionEdgeInsets(atIndex: index)
  }
  
}
