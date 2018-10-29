//
//  AbsoluteLayoutElement.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/7.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import CoreGraphics

/**
 *  Layout options that can be defined for an ASLayoutElement being added to a ASAbsoluteLayoutSpec.
 */
protocol AbsoluteLayoutElement {
  
  /**
   * @abstract The position of this object within its parent spec.
   */
  var layoutPosition: CGPoint { get set }
  
}
