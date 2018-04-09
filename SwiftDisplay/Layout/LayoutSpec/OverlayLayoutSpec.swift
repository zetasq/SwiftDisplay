//
//  OverlayLayoutSpec.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/14.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

/**
 This layout spec lays out a single layoutElement child and then overlays a layoutElement object on top of it streched to its size
 */
final class OverlayLayoutSpec: LayoutSpec {
  
  /**
   * Overlay layoutElement of this layout spec
   */
  var overlay: LayoutElement {
    get {
      return child(atIndex: 1)
    }
    set {
      setChild(newValue, atIndex: 1)
    }
  }
  
  /**
   * Creates and returns an ASOverlayLayoutSpec object with a given child and an layoutElement that act as overlay.
   *
   * @param child A child that is laid out to determine the size of this spec.
   * @param overlay A layoutElement object that is laid out over the child.
   */
  init(child: LayoutElement, overlay: LayoutElement) {
    super.init()
    
    self.child = child
    self.overlay = overlay
  }
  
  /**
   First layout the contents, then fit the overlay on top of it.
   */
  func calculateLayoutThatFits(_ constrainedSize: SizeRange, restrictedTo size: LayoutElementSize, relativeTo parentSize: CGSize) -> Layout {
    let contentsLayout = child.layoutThatFits(constrainedSize, parentSize: parentSize)
    contentsLayout.position = .zero
    
    var sublayouts = [contentsLayout]
    
    let overlayLayout = overlay.layoutThatFits(SizeRange(exactSize: contentsLayout.size), parentSize: contentsLayout.size)
    overlayLayout.position = .zero
    sublayouts.append(overlayLayout)
    
    return Layout(layoutElement: self, size: contentsLayout.size, position: nil, sublayouts: sublayouts)
  }
  
}
