//
//  LayoutElementStyleExtensions.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/9.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

// Provides extension points for elments that comply to ASLayoutElement like ASLayoutSpec to add additional
// properties besides the default one provided in ASLayoutElementStyle
struct LayoutElementStyleExtensions {
  
  var boolExtensions: [Bool]
  
  var integerExtensions: [Int]
  
  var edgeInsetsExtensions: [UIEdgeInsets]
  
  init() {
    self.boolExtensions = Array(repeating: false, count: 4)
    self.integerExtensions = Array(repeating: 0, count: 4)
    self.edgeInsetsExtensions = Array(repeating: .zero, count: 4)
  }
  
}
