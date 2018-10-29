//
//  StackLayoutSpec.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/14.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import CoreGraphics

/**
 A simple layout spec that stacks a list of children vertically or horizontally.
 
 - All children are initially laid out with the an infinite available size in the stacking direction.
 - In the other direction, this spec's constraint is passed.
 - The children's sizes are summed in the stacking direction.
 - If this sum is less than this spec's minimum size in stacking direction, children with flexGrow are flexed.
 - If it is greater than this spec's maximum size in the stacking direction, children with flexShrink are flexed.
 - If, even after flexing, the sum is still greater than this spec's maximum size in the stacking direction,
 justifyContent determines how children are laid out.
 
 For example:
 
 - Suppose stacking direction is Vertical, min-width=100, max-width=300, min-height=200, max-height=500.
 - All children are laid out with min-width=100, max-width=300, min-height=0, max-height=INFINITY.
 - If the sum of the childrens' heights is less than 200, children with flexGrow are flexed larger.
 - If the sum of the childrens' heights is greater than 500, children with flexShrink are flexed smaller.
 Each child is shrunk by `((sum of heights) - 500)/(number of flexShrink-able children)`.
 - If the sum of the childrens' heights is greater than 500 even after flexShrink-able children are flexed,
 justifyContent determines how children are laid out.
 */
public final class StackLayoutSpec: LayoutSpec {
  
  /**
   Specifies the direction children are stacked in. If horizontalAlignment and verticalAlignment were set,
   they will be resolved again, causing justifyContent and alignItems to be updated accordingly
   */
  public var direction: StackLayoutDirection = .horizontal
  
  /** The amount of space between each child. */
  public var spacing: CGFloat = 5
  
  /**
   Specifies how children are aligned horizontally. Depends on the stack direction, setting the alignment causes either
   justifyContent or alignItems to be updated. The alignment will remain valid after future direction changes.
   Thus, it is preferred to those properties
   */
  public var horizontalAlignment: HorizontalAlignment = .none
  
  /**
   Specifies how children are aligned vertically. Depends on the stack direction, setting the alignment causes either
   justifyContent or alignItems to be updated. The alignment will remain valid after future direction changes.
   Thus, it is preferred to those properties
   */
  public var verticalAlignment: VerticalAlignment = .none
  
  /** The amount of space between each child. Defaults to ASStackLayoutJustifyContentStart */
  public var justifyContent: StackLayoutJustifyContent = .start
  
  /** Orientation of children along cross axis. Defaults to ASStackLayoutAlignItemsStretch */
  public var alignItems: StackLayoutAlignItems = .start
  
  /** Whether children are stacked into a single or multiple lines. Defaults to single line (ASStackLayoutFlexWrapNoWrap) */
  public var flexWrap: StackLayoutFlexWrap = .noWrap
  
  /** Orientation of lines along cross axis if there are multiple lines. Defaults to ASStackLayoutAlignContentStart */
  public var alignContent: StackLayoutAlignContent = .start
  
  /** If the stack spreads on multiple lines using flexWrap, the amount of space between lines. */
  public var lineSpacing: CGFloat = 5
  
  /** Whether this stack can dispatch to other threads, regardless of which thread it's running on */
  public var isConcurrent: Bool = false

}
