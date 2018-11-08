//
//  SizeRange.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/7.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import CoreGraphics

/**
 * Expresses an inclusive range of sizes. Used to provide a simple constraint to layout.
 */
public struct SizeRange: Equatable {
  
  /**
   * A size range with all dimensions zero.
   */
  public static let zero = SizeRange(minSize: .zero, maxSize: .zero)
  
  /**
   * A size range from zero to infinity in both directions.
   */
  public static let unconstrained = SizeRange(
    minSize: CGSize(width: 0, height: 0),
    maxSize: CGSize(width: CGFloat.infinity, height: CGFloat.infinity)
  )
  
  public let minSize: CGSize
  
  public let maxSize: CGSize
  
  /**
   * Creates an ASSizeRange with provided min and max size.
   */
  public init(minSize: CGSize, maxSize: CGSize) {
    assert(minSize.width >= 0 && minSize.width <= .greatestFiniteMagnitude)
    assert(minSize.height >= 0 && minSize.height <= .greatestFiniteMagnitude)
    assert(minSize.width <= maxSize.width)
    assert(minSize.height <= maxSize.height)
    
    self.minSize = minSize
    self.maxSize = maxSize
  }
  
  /**
   * Creates an ASSizeRange with provided size as both min and max.
   */
  public init(exactSize: CGSize) {
    self.init(minSize: exactSize, maxSize: exactSize)
  }
  
  /**
   * Returns whether a size range has > 0.1 max width and max height.
   */
  public var hasSignificantArea: Bool {
    return self.maxSize.width > 0.1 && self.maxSize.height > 0.1
  }
  
  /**
   * Clamps the provided CGSize between the [min, max] bounds of this ASSizeRange.
   */
  public func clamp(size: CGSize) -> CGSize {
    return CGSize(
      width: max(self.minSize.width, min(self.maxSize.width, size.width)),
      height: max(self.minSize.height, min(self.maxSize.height, size.height))
    )
  }
  
  
  private struct _Range {
    let minVal: CGFloat
    let maxVal: CGFloat
    
    func intersect(_ range: _Range) -> _Range {
      let newMinVal = max(self.minVal, range.minVal)
      let newMaxVal = min(self.maxVal, range.maxVal)
      
      if newMinVal <= newMaxVal {
        return _Range(minVal: newMinVal, maxVal: newMaxVal)
      } else {
        if self.minVal < range.minVal {
          return _Range(minVal: self.maxVal, maxVal: self.maxVal)
        } else {
          return _Range(minVal: self.minVal, maxVal: self.minVal)
        }
      }
    }
  }
  
  /**
   * Intersects another size range. If the other size range does not overlap in either dimension, this size range
   * "wins" by returning a single point within its own range that is closest to the non-overlapping range.
   */
  public func intersect(_ sizeRange: SizeRange) -> SizeRange {
    let widthRange = _Range(minVal: self.minSize.width, maxVal: self.maxSize.width).intersect(_Range(minVal: sizeRange.minSize.width, maxVal: sizeRange.maxSize.width))
    
    let heightRange = _Range(minVal: self.minSize.height, maxVal: self.maxSize.height).intersect(_Range(minVal: sizeRange.minSize.height, maxVal: sizeRange.maxSize.height))
    
    return SizeRange(
      minSize: CGSize(width: widthRange.minVal, height: heightRange.minVal),
      maxSize: CGSize(width: widthRange.maxVal, height: heightRange.maxVal)
    )
  }
  
}

extension SizeRange: CustomDebugStringConvertible {
  public var debugDescription: String {
    if self.minSize == self.maxSize {
      return String(format: "{{%.*g, %.*g}}", 17, self.minSize.width, 17, self.minSize.height)
    } else {
      return String(format: "{{%.*g, %.*g}, {%.*g, %.*g}}",
                    17, self.minSize.width,
                    17, self.minSize.height,
                    17, self.maxSize.width,
                    17, self.maxSize.height)
    }
  }
}
