//
//  RatioLayoutSpec.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/14.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

/**
 Ratio layout spec
 For when the content should respect a certain inherent ratio but can be scaled (think photos or videos)
 The ratio passed is the ratio of height / width you expect
 
 For a ratio 0.5, the spec will have a flat rectangle shape
 _ _ _ _
 |       |
 |_ _ _ _|
 
 For a ratio 2.0, the spec will be twice as tall as it is wide
 _ _
 |   |
 |   |
 |   |
 |_ _|
 
 **/
final class RatioLayoutSpec: LayoutSpec {
  
  var ratio: CGFloat {
    didSet {
      assert(isMutable, "Cannot set properties when layout spec is not mutable")
    }
  }
  
  init(ratio: CGFloat, child: LayoutElement) {
    assert(ratio > 0, "Ratio should be strictly positive, but received \(ratio)")
    
    self.ratio = ratio
    
    super.init()
    
    self.child = child
  }
  
  override func calculateLayoutThatFits(_ constrainedSize: SizeRange) -> Layout {
    var sizeOptions: [CGSize] = [];
    
    if constrainedSize.maxSize.width.isValidForSize {
      sizeOptions.append(constrainedSize.clamp(size: CGSize(
        width: constrainedSize.maxSize.width,
        height: (ratio * constrainedSize.maxSize.width).floorPixelValue
      )))
    }
    
    if constrainedSize.maxSize.height.isValidForSize {
      sizeOptions.append(constrainedSize.clamp(size: CGSize(
        width: (constrainedSize.maxSize.height / ratio).floorPixelValue,
        height: constrainedSize.maxSize.height
      )))
    }
    
    let childRange: SizeRange
    let parentSize: CGSize
    
    // Choose the size closest to the desired ratio.
    // If there is no max size in *either* dimension, we can't apply the ratio, so just pass our size range through.
    if let bestSize = sizeOptions.max(by: {
      abs($0.height / $0.width - ratio) > abs($1.height / $1.width - ratio)
    }) {
      childRange = constrainedSize.intersect(SizeRange(exactSize: bestSize))
      parentSize = bestSize
    } else {
      childRange = constrainedSize
      parentSize = LayoutElementParentSizeUndefined
    }
    
    let sublayout = child.layoutThatFits(childRange, parentSize: parentSize)
    
    return Layout(layoutElement: self, size: sublayout.size, position: nil, sublayouts: [sublayout])
  }
  
}
