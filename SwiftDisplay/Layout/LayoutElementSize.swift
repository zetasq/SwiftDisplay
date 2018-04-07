//
//  LayoutElementSize.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/7.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

/**
 * A struct specifying a LayoutElement's size. Example:
 *
 *  ASLayoutElementSize size = (ASLayoutElementSize){
 *    .width = ASDimensionMakeWithFraction(0.25),
 *    .maxWidth = ASDimensionMakeWithPoints(200),
 *    .minHeight = ASDimensionMakeWithFraction(0.50)
 *  };
 *
 *  Description: <ASLayoutElementSize: exact={25%, Auto}, min={Auto, 50%}, max={200pt, Auto}>
 *
 */
struct LayoutElementSize: Equatable {
  
  enum FieldName {
    case width
    case height
    case minWidth
    case maxWidth
    case minHeight
    case maxHeight
  }
  
  static let auto = LayoutElementSize(
    width: .auto,
    height: .auto,
    minWidth: .auto,
    maxWidth: .auto,
    minHeight: .auto,
    maxHeight: .auto
  )
  
  var width: Dimension
  var height: Dimension
  var minWidth: Dimension
  var maxWidth: Dimension
  var minHeight: Dimension
  var maxHeight: Dimension
  
  init(width: Dimension, height: Dimension, minWidth: Dimension, maxWidth: Dimension, minHeight: Dimension, maxHeight: Dimension) {
    self.width = width
    self.height = height
    self.minWidth = minWidth
    self.maxWidth = maxWidth
    self.minHeight = minHeight
    self.maxHeight = maxHeight
  }
  
  init(size: CGSize) {
    self = LayoutElementSize.auto
    self.width = .fixed(value: size.width)
    self.height = .fixed(value: size.height)
  }
  
  init(desc: [FieldName: Dimension]) {
    self = .auto
    for (fieldName, dimension) in desc {
      self[fieldName] = dimension
    }
  }
  
  subscript(_ fieldName: FieldName) -> Dimension {
    get {
      switch fieldName {
      case .width:
        return self.width
      case .height:
        return self.height
      case .minWidth:
        return self.minWidth
      case .maxWidth:
        return self.maxWidth
      case .minHeight:
        return self.minHeight
      case .maxHeight:
        return self.maxHeight
      }
    }
    set {
      switch fieldName {
      case .width:
        self.width = newValue
      case .height:
        self.height = newValue
      case .minWidth:
        self.minWidth = newValue
      case .maxWidth:
        self.maxWidth = newValue
      case .minHeight:
        self.minHeight = newValue
      case .maxHeight:
        self.maxHeight = newValue
      }
    }
  }
  
  /**
   * Resolve the given size relative to a parent size and an auto size.
   * From the given size uses width, height to resolve the exact size constraint, uses the minHeight and minWidth to
   * resolve the min size constraint and the maxHeight and maxWidth to resolve the max size constraint. For every
   * dimension with unit ASDimensionUnitAuto the given autoASSizeRange value will be used.
   * Based on the calculated exact, min and max size constraints the final size range will be calculated.
   */
  func resolve(withParentSize parentSize: CGSize, autoSizeRange: SizeRange = SizeRange(minSize: .zero, maxSize: CGSize(width: CGFloat.infinity, height: CGFloat.infinity))) -> SizeRange {
    let resolvedExact = LayoutSize(width: self.width, height: self.height).resolve(withParentSize: parentSize, autoSize: CGSize(width: CGFloat.nan, height: CGFloat.nan))
    
    let resolvedMin = LayoutSize(width: self.minWidth, height: self.minHeight).resolve(withParentSize: parentSize, autoSize: autoSizeRange.minSize)
    
    let resolvedMax = LayoutSize(width: self.maxWidth, height: self.maxHeight).resolve(withParentSize: parentSize, autoSize: autoSizeRange.maxSize)
    
    let (rangeMinWidth, rangeMaxWidth) = LayoutElementSize.constrain(minVal: resolvedMin.width, exactVal: resolvedExact.width, maxVal: resolvedMax.width)
    let (rangeMinHeight, rangeMaxHeight) = LayoutElementSize.constrain(minVal: resolvedMin.height, exactVal: resolvedExact.height, maxVal: resolvedMax.height)
    
    return SizeRange(minSize: CGSize(width: rangeMinWidth, height: rangeMinHeight), maxSize: CGSize(width: rangeMaxWidth, height: rangeMaxHeight))
  }
  
  static func constrain(minVal: CGFloat, exactVal: CGFloat, maxVal: CGFloat) -> (outputMin: CGFloat, outputMax: CGFloat) {
    assert(!minVal.isNaN, "minVal must not be NaN")
    assert(!maxVal.isNaN, "maxVal must not be NaN")
    
    // Avoid use of min/max primitives since they're harder to reason
    // about in the presence of NaN (in exactVal)
    // Follow CSS: min overrides max overrides exact.
    
    // Begin with the min/max range
    var outputMin = minVal
    var outputMax = maxVal
    
    if maxVal <= minVal {
      // min overrides max and exactVal is irrelevant
      outputMax = minVal
    } else if !exactVal.isNaN {
      if exactVal > maxVal {
        // clip to max value
        outputMin = maxVal
      } else if exactVal < minVal {
        // clip to min value
        outputMax = minVal
      } else {
        // use exact value
        outputMin = exactVal
        outputMax = exactVal
      }
    } else {
      // no exact value, so leave as a min/max range
    }
    
    return (outputMin, outputMax)
  }
}

extension LayoutElementSize: CustomDebugStringConvertible {
  var debugDescription: String {
    return "<LayoutElementSize: exact="
      + LayoutSize(width: self.width, height: self.height).debugDescription
      + ", min=" + LayoutSize(width: self.minWidth, height: self.minHeight).debugDescription
      + ", max=" + LayoutSize(width: self.maxWidth, height: self.maxHeight).debugDescription
      + ">"
  }
}
