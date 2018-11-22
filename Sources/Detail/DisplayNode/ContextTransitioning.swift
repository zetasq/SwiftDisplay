//
//  ContextTransitioning.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/11/10.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import CoreGraphics

public enum TransitionContextKey {
  
  case originLayout
  
  case targetLayout
  
}

public protocol ContextTransitioning: AnyObject {
  
  /**
   @abstract Defines if the given transition is animated
   */
  var isAnimated: Bool { get }
  
  /**
   * @abstract Retrieve either the "from" or "to" layout
   */
  func layout(forKey key: TransitionContextKey) -> Layout?
  
  /**
   * @abstract Retrieve either the "from" or "to" constrainedSize
   */
  func constrainedSize(forKey key: TransitionContextKey) -> SizeRange
  
  /**
   * @abstract Retrieve the subnodes from either the "from" or "to" layout
   */
  func subnodes(forKey key: TransitionContextKey) -> [DisplayNode]
  
  /**
   * @abstract Subnodes that have been inserted in the layout transition
   */
  var insertedSubnodes: [DisplayNode] { get }
  
  /**
   * @abstract Subnodes that will be removed in the layout transition
   */
  var removedSubnodes: [DisplayNode] { get }
  
  /**
   @abstract The frame for the given node before the transition began.
   @discussion Returns CGRectNull if the node was not in the hierarchy before the transition.
   */
  func initialFrame(forNode node: DisplayNode) -> CGRect
  
  /**
   @abstract The frame for the given node when the transition completes.
   @discussion Returns CGRectNull if the node is no longer in the hierarchy after the transition.
   */
  func finalFrame(forNode node: DisplayNode) -> CGRect
  
  /**
   @abstract Invoke this method when the transition is completed in `animateLayoutTransition:`
   @discussion Passing NO to `didComplete` will set the original layout as the new layout.
   */
  func completeTransition(_ didComplete: Bool)
  
}
