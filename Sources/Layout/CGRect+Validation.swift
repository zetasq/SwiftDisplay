//
//  CGRect+Validation.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/7.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGFloat {
  
  var isValidForLayout: Bool {
    return (self.isNormal || self == 0) && self < .greatestFiniteMagnitude / 2
  }
  
  var isValidForSize: Bool {
    return self.isValidForLayout && self >= 0
  }
  
}

extension CGSize {
  
  var isValidForLayout: Bool {
    return self.width.isValidForSize
      && self.height.isValidForSize
  }
  
}

extension CGPoint {
  
  var isValidForLayout: Bool {
    return self.x.isValidForLayout && self.y.isValidForLayout
  }
  
}

extension CGRect {
  
  var isValidForLayout: Bool {
    return self.origin.isValidForLayout && self.size.isValidForLayout
  }
  
}
