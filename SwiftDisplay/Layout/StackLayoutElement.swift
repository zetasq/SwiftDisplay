//
//  StackLayoutElement.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 9/4/2018.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

/**
 *  Layout options that can be defined for an ASLayoutElement being added to a ASStackLayoutSpec.
 */
protocol StackLayoutElement {

/**
 * @abstract Additional space to place before this object in the stacking direction.
 * Used when attached to a stack layout.
 */
  var spacingBefore: CGFloat { get set }

/**
 * @abstract Additional space to place after this object in the stacking direction.
 * Used when attached to a stack layout.
 */
  var spacingAfter: CGFloat { get set }

/**
 * @abstract If the sum of childrens' stack dimensions is less than the minimum size, how much should this component grow?
 * This value represents the "flex grow factor" and determines how much this component should grow in relation to any
 * other flexible children.
 */
  var flexGrow: CGFloat { get set }

/**
 * @abstract If the sum of childrens' stack dimensions is greater than the maximum size, how much should this component shrink?
 * This value represents the "flex shrink factor" and determines how much this component should shink in relation to
 * other flexible children.
 */
  var flexShrink: CGFloat { get set }

/**
 * @abstract Specifies the initial size in the stack dimension for this object.
 * Defaults to ASDimensionAuto.
 * Used when attached to a stack layout.
 */
  var flexBasis: Dimension { get set }

/**
 * @abstract Orientation of the object along cross axis, overriding alignItems.
 * Defaults to ASStackLayoutAlignSelfAuto.
 * Used when attached to a stack layout.
 */
  var alignSelf: StackLayoutAlignSelf { get set }

/**
 *  @abstract Used for baseline alignment. The distance from the top of the object to its baseline.
 */
  var ascender: CGFloat { get set }

/**
 *  @abstract Used for baseline alignment. The distance from the baseline of the object to its bottom.
 */
  var descender: CGFloat { get set }

}
