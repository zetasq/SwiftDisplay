//
//  BackgroundLayoutSpec.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/12.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

/**
 Lays out a single layoutElement child, then lays out a background layoutElement instance behind it stretched to its size.
 */
final class BackgroundLayoutSpec: LayoutSpec {
  
  var background: LayoutElement {
    get {
      return super.child(atIndex: 1)
    }
    set {
      super.setChild(newValue, atIndex: 1)
    }
  }
  
  /**
   * Creates and returns an ASBackgroundLayoutSpec object
   *
   * @param child A child that is laid out to determine the size of this spec.
   * @param background A layoutElement object that is laid out behind the child.
   */
  init(child: LayoutElement, background: LayoutElement) {
    super.init()
    
    self.child = child
    self.background = background
  }
  
  /**
   * First layout the contents, then fit the background image.
   */
  func calculateLayoutThatFits(_ constrainedSize: SizeRange, restrictedTo size: LayoutElementSize, relativeTo parentSize: CGSize) -> Layout {
    let contentsLayout = child.layoutThatFits(constrainedSize, parentSize: parentSize)
    
    var sublayouts: [Layout] = []
    
    // Size background to exactly the same size
    let backgroundLayout = background.layoutThatFits(SizeRange(exactSize: contentsLayout.size), parentSize: parentSize)
    backgroundLayout.position = .zero
    sublayouts.append(backgroundLayout)
    
    contentsLayout.position = .zero
    sublayouts.append(contentsLayout)
    
    return Layout(layoutElement: self, size: contentsLayout.size, position: nil, sublayouts: sublayouts)
  }
}
