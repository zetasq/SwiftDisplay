//
//  LayoutElementExtensibility.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/7.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

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
