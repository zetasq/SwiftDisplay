//
//  UIView+AsyncDisplay.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/11/10.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import UIKit

/** UIVIew(AsyncDisplayKit) defines convenience method for adding sub-ASDisplayNode to an UIView. */
extension UIView {
  
  /**
   * Convenience method, equivalent to [view addSubview:node.view] or [view.layer addSublayer:node.layer] if layer-backed.
   *
   * @param node The node to be added.
   */
  public final func addSubnode(_ node: DisplayNode) {
    fatalError()
  }
  
}
