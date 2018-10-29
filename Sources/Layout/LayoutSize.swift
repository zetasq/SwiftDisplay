//
//  LayoutSize.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/7.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import CoreGraphics

/**
 * Expresses a size with relative dimensions. Only used for calculations internally in ASDimension.h
 */
struct LayoutSize {
  
  static let auto = LayoutSize(width: .auto, height: .auto)
  
  let width: Dimension
  
  let height: Dimension
  
  /**
   * Resolve this relative size relative to a parent size.
   */
  func resolve(withParentSize parentSize: CGSize, autoSize: CGSize) -> CGSize {
    return CGSize(
      width: width.resolve(withParentSize: parentSize.width, autoSize: autoSize.width),
      height: height.resolve(withParentSize: parentSize.height, autoSize: autoSize.height)
    )
  }
  
}

extension LayoutSize: CustomDebugStringConvertible {
  var debugDescription: String {
    return "{\(width.debugDescription), \(height.debugDescription)}"
  }
}
