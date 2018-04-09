//
//  AbsoluteLayoutSpec.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/7.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation



/**
 A layout spec that positions children at fixed positions.
 */
final class AbsoluteLayoutSpec: LayoutSpec {
  
  /** How much space the spec will take up. */
  enum Sizing {
    /** The spec will take up the maximum size possible. */
    case `default`
    /** Computes a size for the spec that is the union of all childrens' frames. */
    case sizeToFit
  }
  
  /**
   How much space will the spec taken up
   */
  var sizing: Sizing
  
  /**
   @param sizing How much space the spec will take up
   @param children Children to be positioned at fixed positions
   */
  init(sizing: Sizing = .default, children: [LayoutElement]) {
    self.sizing = sizing

    super.init()
    
    self.children = children
  }
  
  override func calculateLayoutThatFits(_ constrainedSize: SizeRange) -> Layout {
    var size = CGSize(
      width: !constrainedSize.maxSize.width.isValidForSize ? LayoutElementParentDimensionUndefined : constrainedSize.maxSize.width,
      height: !constrainedSize.maxSize.height.isValidForSize ? LayoutElementParentDimensionUndefined : constrainedSize.maxSize.height)
    
    let childElements = self.children
    
    var sublayouts: [Layout] = []
    
    for element in childElements {
      let layoutPosition = element.style.layoutPosition
      let autoMaxSize = CGSize(width: constrainedSize.maxSize.width - layoutPosition.x, height: constrainedSize.maxSize.height - layoutPosition.y)
      
      let childConstraint = element.style.size.resolve(withParentSize: size, autoSizeRange: SizeRange(minSize: .zero, maxSize: autoMaxSize))
      
      let sublayout = element.layoutThatFits(childConstraint, parentSize: size)
      sublayout.position = layoutPosition
      sublayouts.append(sublayout)
    }
    
    if sizing == .sizeToFit || size.width.isNaN {
      size.width = constrainedSize.minSize.width
      for sublayout in sublayouts {
        size.width = max(size.width, sublayout.position!.x + sublayout.size.width)
      }
    }
    
    if sizing == .sizeToFit || size.height.isNaN {
      size.height = constrainedSize.minSize.height
      for sublayout in sublayouts {
        size.height = max(size.height, sublayout.position!.y + sublayout.size.height)
      }
    }
    
    return Layout(layoutElement: self, size: constrainedSize.clamp(size: size), position: nil, sublayouts: sublayouts)
  }
}
