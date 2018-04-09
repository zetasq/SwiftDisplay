//
//  RelativeLayoutSpec.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/13.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

/** Lays out a single layoutElement child and positions it within the layout bounds according to vertical and horizontal positional specifiers.
 *  Can position the child at any of the 4 corners, or the middle of any of the 4 edges, as well as the center - similar to "9-part" image areas.
 */
final class RelativeLayoutSpec: LayoutSpec {
  
  /**
   * How the child is positioned within the spec.
   *
   * The default option will position the child at point 0.
   * Swift: use [] for the default behavior.
   */
  enum Position {
    /** The child is positioned at point 0 */
    case none
    /** The child is positioned at point 0 relatively to the layout axis (ie left / top most) */
    case start
    /** The child is centered along the specified axis */
    case center
    /** The child is positioned at the maximum point of the layout axis (ie right / bottom most) */
    case end
    
    var proportionOfAxis: CGFloat {
      switch self {
      case .center:
        return 0.5
      case .end:
        return 1
      default:
        return 0
      }
    }
  }
  
  /**
   * How much space the spec will take up.
   *
   * The default option will allow the spec to take up the maximum size possible.
   * Swift: use [] for the default behavior.
   */
  struct SizingOption: OptionSet {
    let rawValue: Int
    
    /** The spec will take up the maximum size possible */
    static let `default` = SizingOption(rawValue: 0)
    
    /** The spec will take up the minimum size possible along the X axis */
    static let minimumWidth = SizingOption(rawValue: 1 << 0)

    /** The spec will take up the minimum size possible along the Y axis */
    static let minimumHeight = SizingOption(rawValue: 1 << 1)

    /** Convenience option to take up the minimum size along both the X and Y axis */
    static let minimumSize: [SizingOption] = [.minimumWidth, .minimumHeight]
  }
  
  // You may create a spec with alloc / init, then set any non-default properties; or use a convenience initialize that accepts all properties.
  var horizontalPosition: Position {
    didSet {
      assert(isMutable, "Cannot set properties when layout spec is not mutable")
    }
  }
  
  var verticalPosition: Position {
    didSet {
      assert(isMutable, "Cannot set properties when layout spec is not mutable")
    }
  }
  
  var sizingOption: SizingOption {
    didSet {
      assert(isMutable, "Cannot set properties when layout spec is not mutable")
    }
  }
  
  /*!
   * @discussion convenience initializer for a ASRelativeLayoutSpec
   * @param horizontalPosition how to position the item on the horizontal (x) axis
   * @param verticalPosition how to position the item on the vertical (y) axis
   * @param sizingOption how much size to take up
   * @param child the child to layout
   * @return a configured ASRelativeLayoutSpec
   */
  init(horizontalPosition: Position,
       verticalPosition: Position,
       sizingOption: SizingOption,
       child: LayoutElement) {
    self.horizontalPosition = horizontalPosition
    self.verticalPosition = verticalPosition
    self.sizingOption = sizingOption
    
    super.init()
    
    self.child = child
  }
  
  override func calculateLayoutThatFits(_ constrainedSize: SizeRange) -> Layout {
    // If we have a finite size in any direction, pass this so that the child can resolve percentages against it.
    // Otherwise pass ASLayoutElementParentDimensionUndefined as the size will depend on the content
    var size = CGSize(
      width: constrainedSize.maxSize.width.isValidForSize ? constrainedSize.maxSize.width : LayoutElementParentDimensionUndefined,
      height: constrainedSize.maxSize.height.isValidForSize ? constrainedSize.maxSize.height : LayoutElementParentDimensionUndefined
    )
    
    // Layout the child
    let minChildSize = CGSize(
      width: horizontalPosition == .none ? constrainedSize.minSize.width : 0,
      height: verticalPosition == .none ? constrainedSize.minSize.height : 0
    )
    
    let sublayout = child.layoutThatFits(SizeRange(minSize: minChildSize, maxSize: constrainedSize.minSize), parentSize: size)
    
    // If we have an undetermined height or width, use the child size to define the layout size
    size = constrainedSize.clamp(size: CGSize(
      width: size.width.isFinite ? size.width : sublayout.size.width,
      height: size.height.isFinite ? size.height : sublayout.size.height
    ))
    
    // If minimum size options are set, attempt to shrink the size to the size of the child
    size = constrainedSize.clamp(size: CGSize(
      width: min(size.width, sizingOption.contains(.minimumWidth) ? sublayout.size.width : size.width),
      height: min(size.height, sizingOption.contains(.minimumHeight) ? sublayout.size.height : size.height)
    ))
    
    // Compute the position for the child on each axis according to layout parameters
    let xProportion = horizontalPosition.proportionOfAxis
    let yProportion = verticalPosition.proportionOfAxis
    
    sublayout.position = CGPoint(
      x: ((size.width - sublayout.size.width) * xProportion).roundPixelValue,
      y: ((size.height - sublayout.size.height) * yProportion).roundPixelValue
    )
    
    return Layout(layoutElement: self, size: size, position: nil, sublayouts: [sublayout])
  }
  
  private func proportionOfAxis(for position: Position) -> CGFloat {
    switch position {
    case .center:
      return 0.5
    case .end:
      return 1
    default:
      return 0
    }
  }
  
}
