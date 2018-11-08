//
//  DisplayNode+Subtypes.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/11/8.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import UIKit

extension DisplayNode {
  
  /**
   * UIView creation block. Used to create the backing view of a new display node.
   */
  public typealias ViewBlock = () -> UIView
  
  /**
   * UIViewController creation block. Used to create the backing viewController of a new display node.
   */
  public typealias ViewControllerBlock = () -> UIViewController
  
  /**
   * CALayer creation block. Used to create the backing layer of a new display node.
   */
  public typealias LayerBlock = () -> CALayer
  
  /**
   * ASDisplayNode loaded callback block. This block is called BEFORE the -didLoad method and is always called on the main thread.
   */
  public typealias DidLoadBlock = (DisplayNode) -> Void
  
  /**
   * ASDisplayNode will / did render node content in context.
   */
  public typealias ContextModifier = (CGContext, Any?) -> Void
  
  /**
   * ASDisplayNode layout spec block. This block can be used instead of implementing layoutSpecThatFits: in subclass
   */
  public typealias LayoutSpecBlock = (DisplayNode, SizeRange) -> LayoutSpec
  
  /**
   * AsyncDisplayKit non-fatal error block. This block can be used for handling non-fatal errors. Useful for reporting
   * errors that happens in production.
   */
  public typealias NonFatalErrorBlock = (Error) -> Void
  
  public enum CornerRoundingType {
    
    case defaultSlowCALayer
    
    case precomposited
    
    case clipping
    
  }
  
}
