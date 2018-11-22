//
//  CALayer+AsyncDisplay.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/11/10.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import UIKit

/*
 * CALayer(AsyncDisplayKit) defines convenience method for adding sub-ASDisplayNode to a CALayer.
 */
extension CALayer {
  
  /**
   * Convenience method, equivalent to [layer addSublayer:node.layer].
   *
   * @param node The node to be added.
   */
  public final func addSubnode(_ node: DisplayNode) {
    fatalError()
  }
  
}
