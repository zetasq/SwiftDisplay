//
//  StackLayoutDefines.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 9/4/2018.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

/** The direction children are stacked in */
enum StackLayoutDirection {
  /** Children are stacked vertically */
  case vertical
  /** Children are stacked horizontally */
  case horizontal
}

/** If no children are flexible, how should this spec justify its children in the available space? */
enum StackLayoutJustifyContent {
  /**
   On overflow, children overflow out of this spec's bounds on the right/bottom side.
   On underflow, children are left/top-aligned within this spec's bounds.
   */
  case start
  
  /**
   On overflow, children are centered and overflow on both sides.
   On underflow, children are centered within this spec's bounds in the stacking direction.
   */
  case center
  
  /**
   On overflow, children overflow out of this spec's bounds on the left/top side.
   On underflow, children are right/bottom-aligned within this spec's bounds.
   */
  case end
  
  /**
   On overflow or if the stack has only 1 child, this value is identical to ASStackLayoutJustifyContentStart.
   Otherwise, the starting edge of the first child is at the starting edge of the stack, 
   the ending edge of the last child is at the ending edge of the stack, and the remaining children
   are distributed so that the spacing between any two adjacent ones is the same.
   If there is a remaining space after spacing division, it is combined with the last spacing (i.e the one between the last 2 children).
   */
  case spaceBetween
  
  /**
   On overflow or if the stack has only 1 child, this value is identical to ASStackLayoutJustifyContentCenter.
   Otherwise, children are distributed such that the spacing between any two adjacent ones is the same,
   and the spacing between the first/last child and the stack edges is half the size of the spacing between children.
   If there is a remaining space after spacing division, it is combined with the last spacing (i.e the one between the last child and the stack ending edge).
   */
  case spaceAround
}

/** Orientation of children along cross axis */
enum StackLayoutAlignItems {
  /** Align children to start of cross axis */
  case start
  /** Align children with end of cross axis */
  case end
  /** Center children on cross axis */
  case center
  /** Expand children to fill cross axis */
  case stretch
  /** Children align to their first baseline. Only available for horizontal stack spec */
  case baselineFirst
  /** Children align to their last baseline. Only available for horizontal stack spec */
  case baselineLast
  
  case notSet
}

/**
 Each child may override their parent stack's cross axis alignment.
 @see ASStackLayoutAlignItems
 */
enum StackLayoutAlignSelf {
  /** Inherit alignment value from containing stack. */
  case auto
  /** Align to start of cross axis */
  case start
  /** Align with end of cross axis */
  case end
  /** Center on cross axis */
  case center
  /** Expand to fill cross axis */
  case stretch
}

/** Whether children are stacked into a single or multiple lines. */
enum StackLayoutFlexWrap {
  case noWrap
  case wrap
}

/** Orientation of lines along cross axis if there are multiple lines. */
enum StackLayoutAlignContent {
  case start
  case center
  case end
  case spaceBetween
  case spaceAround
  case stretch
}

/** Orientation of children along horizontal axis */
enum HorizontalAlignment {
  /** No alignment specified. Default value */
  case none
  /** Left aligned */
  case left
  /** Center aligned */
  case middle
  /** Right aligned */
  case right
}

/** Orientation of children along vertical axis */
enum VerticalAlignment {
  /** No alignment specified. Default value */
  case none
  /** Top aligned */
  case top
  /** Center aligned */
  case center
  /** Bottom aligned */
  case bottom
}
