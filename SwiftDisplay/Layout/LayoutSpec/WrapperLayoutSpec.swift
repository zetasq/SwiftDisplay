//
//  WrapperLayoutSpec.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/10.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation


/**
 * An ASLayoutSpec subclass that can wrap one or more ASLayoutElement and calculates the layout based on the
 * sizes of the children. If multiple children are provided the size of the biggest child will be used to for
 * size of this layout spec.
 */
final class WrapperLayoutSpec: LayoutSpec {
  /*
   * Returns an ASWrapperLayoutSpec object with the given layoutElement as child.
   */
  init(layoutElement: LayoutElement) {
    super.init()
    super.setChild(layoutElement, atIndex: 0)
  }
  
  /*
   * Returns an ASWrapperLayoutSpec object with the given layoutElements as children.
   */
  init(layoutElements: [LayoutElement]) {
    super.init()
    children = layoutElements
  }
  
  override func calculateLayoutThatFits(_ constrainedSize: SizeRange) -> Layout {
    let childElements = children
    var sublayouts: [Layout] = []
    
    var size = constrainedSize.minSize
    
    for element in childElements {
      let sublayout = element .layoutThatFits(constrainedSize, parentSize: constrainedSize.maxSize)
      sublayout.position = .zero
      
      size.width = max(size.width, sublayout.size.width)
      size.height = max(size.height, sublayout.size.height)
      
      sublayouts.append(sublayout)
    }
    
    return Layout(layoutElement: self, size: size, position: nil, sublayouts: sublayouts)
  }
}
