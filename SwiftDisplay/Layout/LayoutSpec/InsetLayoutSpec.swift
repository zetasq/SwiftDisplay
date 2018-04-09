//
//  InsetLayoutSpec.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/14.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

/**
 A layout spec that wraps another layoutElement child, applying insets around it.
 
 If the child has a size specified as a fraction, the fraction is resolved against this spec's parent
 size **after** applying insets.
 
 @example ASOuterLayoutSpec contains an ASInsetLayoutSpec with an ASInnerLayoutSpec. Suppose that:
 - ASOuterLayoutSpec is 200pt wide.
 - ASInnerLayoutSpec specifies its width as 100%.
 - The ASInsetLayoutSpec has insets of 10pt on every side.
 ASInnerLayoutSpec will have size 180pt, not 200pt, because it receives a parent size that has been adjusted for insets.
 
 If you're familiar with CSS: ASInsetLayoutSpec's child behaves similarly to "box-sizing: border-box".
 
 An infinite inset is resolved as an inset equal to all remaining space after applying the other insets and child size.
 @example An ASInsetLayoutSpec with an infinite left inset and 10px for all other edges will position it's child 10px from the right edge.
 */
final class InsetLayoutSpec: LayoutSpec {
  
  var insets: UIEdgeInsets {
    didSet {
      assert(isMutable)
    }
  }
  
  /**
   @param insets The amount of space to inset on each side.
   @param child The wrapped child to inset.
   */
  init(insets: UIEdgeInsets, child: LayoutElement) {
    self.insets = insets
    super.init()
    self.child = child
  }
  
  /**
   Inset will compute a new constrained size for it's child after applying insets and re-positioning
   the child to respect the inset.
   */
  func calculateLayoutThatFits(_ constrainedSize: SizeRange, restrictedTo size: LayoutElementSize, relativeTo parentSize: CGSize) -> Layout {
    let insetsX = finiteOrZero(insets.left) + finiteOrZero(insets.right)
    let insetsY = finiteOrZero(insets.top) + finiteOrZero(insets.bottom)
    
    // if either x-axis inset is infinite, let child be intrinsic width
    let minWidth = (insets.left.isFinite && insets.right.isFinite) ? constrainedSize.minSize.width : 0
    // if either y-axis inset is infinite, let child be intrinsic height
    let minHeight = (insets.top.isFinite && insets.bottom.isFinite) ? constrainedSize.minSize.height : 0
    
    let insetConstrainedSize = SizeRange(
      minSize: CGSize(
        width: max(0, minWidth - insetsX),
        height: max(0, minHeight - insetsY)
      ),
      maxSize: CGSize(
        width: max(0, constrainedSize.maxSize.width - insetsY),
        height: max(0, constrainedSize.maxSize.height - insetsY)
      )
    )
    
    let insetParentSize = CGSize(
      width: max(0, parentSize.width - insetsX),
      height: max(0, parentSize.height - insetsY)
    )
    
    let sublayout = child.layoutThatFits(insetConstrainedSize, parentSize: insetParentSize)
    
    let computedSize = constrainedSize.clamp(size: CGSize(
      width: finite(sublayout.size.width + insets.left + insets.right, substitute: constrainedSize.maxSize.width),
      height: finite(sublayout.size.height + insets.top + insets.bottom, substitute: constrainedSize.maxSize.height)
    ))
    
    let x = finite(insets.left,
                   substitute: constrainedSize.maxSize.width - (finite(insets.right, substitute: centerInset(outer: constrainedSize.maxSize.width, inner: sublayout.size.width)) + sublayout.size.width))
    
    let y = finite(insets.top,
                   substitute: constrainedSize.maxSize.height - (finite(insets.bottom, substitute: centerInset(outer: constrainedSize.maxSize.height, inner: sublayout.size.height)) + sublayout.size.height))
    
    sublayout.position = CGPoint(x: x, y: y)
    return Layout(layoutElement: self, size: computedSize, position: nil, sublayouts: [sublayout])
  }
  
  /* Returns f if f is finite, substitute otherwise */
  private func finite(_ f: CGFloat, substitute: CGFloat) -> CGFloat {
    return f.isFinite ? f : substitute
  }
  
  /* Returns f if f is finite, 0 otherwise */
  private func finiteOrZero(_ f: CGFloat) -> CGFloat {
    return finite(f, substitute: 0)
  }
  
  /* Returns the inset required to center 'inner' in 'outer' */
  private func centerInset(outer: CGFloat, inner: CGFloat) -> CGFloat {
    return ((outer - inner) / 2).roundPixelValue
  }

}
