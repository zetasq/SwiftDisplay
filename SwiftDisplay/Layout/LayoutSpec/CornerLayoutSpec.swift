//
//  CornerLayoutSpec.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/14.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

/**
 A layout spec that positions a corner element which relatives to the child element.
 
 @warning Both child element and corner element must have valid preferredSize for layout calculation.
 */
final class CornerLayoutSpec: LayoutSpec {
  
  /**
   The corner location for positioning corner element.
   */
  enum Location {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
  }
  
  /**
   A layoutElement object that is laid out to a corner on the child.
   */
  var corner: LayoutElement {
    get {
      return child(atIndex: 1)
    }
    set {
      setChild(newValue, atIndex: 1)
    }
  }
  
  /**
   The corner position option.
   */
  var cornerLocation: Location
  
  /**
   The point which offsets from the corner location. Use this property to make delta
   distance from the default corner location. Default is CGPointZero.
   */
  var offset: CGPoint = .zero
  
  /**
   Whether should include corner element into layout size calculation. If included,
   the layout size will be the union size of both child and corner; If not included,
   the layout size will be only child's size. Default is NO.
   */
  var wrapsCorner: Bool = false
  
  /**
   A layout spec that positions a corner element which relatives to the child element.
   
   @param child A child that is laid out to determine the size of this spec.
   @param corner A layoutElement object that is laid out to a corner on the child.
   @param location The corner position option.
   @return An ASCornerLayoutSpec object with a given child and an layoutElement that act as corner.
   */
  init(child: LayoutElement, corner: LayoutElement, cornerLocation: Location) {
    self.cornerLocation = cornerLocation

    super.init()
    
    self.child = child
    self.corner = corner
  }
  
  override func calculateLayoutThatFits(_ constrainedSize: SizeRange) -> Layout {
    let size = CGSize(
      width: constrainedSize.maxSize.width.isValidForSize ? constrainedSize.maxSize.width : LayoutElementParentDimensionUndefined,
      height: constrainedSize.maxSize.height.isValidForSize ? constrainedSize.maxSize.height : LayoutElementParentDimensionUndefined
    )
    
    let child = self.child
    let corner = self.corner
    
    // Element validation
    _validate(element: child)
    _validate(element: corner)
    
    var childFrame = CGRect.zero
    var cornerFrame = CGRect.zero
    
    // Layout child
    let childLayout = child.layoutThatFits(constrainedSize, parentSize: size)
    childFrame.size = childLayout.size
    
    // Layout corner
    let cornerLayout = corner.layoutThatFits(constrainedSize, parentSize: size)
    cornerFrame.size = cornerLayout.size
    
    // calcualte corner's position
    let relativePosition = _calculateCornerOrigin(baseFrame: childFrame, cornerSize: cornerFrame.size, cornerLocation: cornerLocation, offset: offset)
    
    // Update corner's position
    cornerFrame.origin = relativePosition
    
    // Calculate size
    var frame = childFrame
    
    if wrapsCorner {
      frame = childFrame.union(cornerFrame)
      frame.size = constrainedSize.clamp(size: frame.size)
    }
    
    // Shift sublayouts' positions if they are off the bounds.
    if frame.origin.x != 0 {
      let deltaX = frame.origin.x
      childFrame.origin.x -= deltaX
      cornerFrame.origin.x -= deltaX
    }
    
    if frame.origin.y != 0 {
      let deltaY = frame.origin.y
      childFrame.origin.y -= deltaY
      cornerFrame.origin.y -= deltaY
    }
    
    childLayout.position = childFrame.origin
    cornerLayout.position = cornerFrame.origin
    
    return Layout(layoutElement: self, size: frame.size, position: nil, sublayouts: [childLayout, cornerLayout])
  }
  
  private func _validate(element: LayoutElement) {
    // Validate preferredSize if needed
    let size = element.style.preferredSize
    if size != .zero && !size.isValidForLayout && (size.width < 0 || size.height < 0) {
      assert(false, "[\(type(of: self))]: Should give a valid preferredSize value for \(element) before corner's position calculation.")
    }
  }
  
  private func _calculateCornerOrigin(baseFrame: CGRect, cornerSize: CGSize, cornerLocation: Location, offset: CGPoint) -> CGPoint {
    var cornerOrigin = CGPoint.zero
    let baseOrigin = baseFrame.origin
    let baseSize = baseFrame.size
    
    switch cornerLocation {
    case .topLeft:
      cornerOrigin.x = baseOrigin.x - cornerSize.width / 2
      cornerOrigin.y = baseOrigin.y - cornerSize.height / 2
    case .topRight:
      cornerOrigin.x = baseOrigin.x + baseSize.width - cornerSize.width / 2
      cornerOrigin.y = baseOrigin.y - cornerSize.height / 2
    case .bottomLeft:
      cornerOrigin.x = baseOrigin.x - cornerSize.width / 2
      cornerOrigin.y = baseOrigin.y + baseSize.height - cornerSize.height / 2
    case .bottomRight:
      cornerOrigin.x = baseOrigin.x + baseSize.width - cornerSize.width / 2
      cornerOrigin.y = baseOrigin.y + baseSize.height - cornerSize.height / 2
    }
    
    cornerOrigin.x += offset.x
    cornerOrigin.y += offset.y
    
    return cornerOrigin
  }
  
}
