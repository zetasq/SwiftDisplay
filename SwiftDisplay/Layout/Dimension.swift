//
//  Dimension.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/6.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation



/**
 * A dimension relative to constraints to be provided in the future.
 * A Dimension can be one of three types:
 *
 * "Auto" - This indicated "I have no opinion" and may be resolved in whatever way makes most sense given the circumstances.
 *
 * "Points" - Just a number. It will always resolve to exactly this amount.
 *
 * "Percent" - Multiplied to a provided parent amount to resolve a final amount.
 */
enum Dimension: Equatable {
    /** This indicates "I have no opinion" and may be resolved in whatever way makes most sense given the circumstances. */
  case auto
    /** Just a number. It will always resolve to exactly this amount. This is the default type. */
  case fixed(value: CGFloat)
    /** Multiplied to a provided parent amount to resolve a final amount. */
  case proportional(fraction: CGFloat)
  
  /**
   * Returns a dimension by parsing the specified dimension string.
   * Examples: ASDimensionMake(@"50%") = ASDimensionMake(ASDimensionUnitFraction, 0.5)
   *           ASDimensionMake(@"0.5pt") = ASDimensionMake(ASDimensionUnitPoints, 0.5)
   */
  init(string: String) {
    assert(!string.isEmpty)
    
    if string.hasSuffix("pt") {
      self = .fixed(value: CGFloat((string as NSString).doubleValue))
    } else if string == "auto" {
      self = .auto
    } else if string.hasSuffix("%") {
      self = .proportional(fraction: CGFloat((string as NSString).doubleValue) / 100.0)
    } else {
      assert(false, "Unrecognized format for Dimention")
      self = .auto
    }
  }
  
  var isValid: Bool {
    switch self {
    case .auto:
      return true
    case .fixed(let value):
      return value >= 0 && value <= .greatestFiniteMagnitude
    case .proportional(let fraction):
      return fraction >= 0 && fraction <= 1
    }
  }
  
  /**
   * Resolve this dimension to a parent size.
   */
  func resolve(withParentSize parentSize: CGFloat, autoSize: CGFloat) -> CGFloat {
    switch self {
    case .auto:
      return autoSize
    case .fixed(let value):
      return value
    case .proportional(let fraction):
      return fraction * parentSize
    }
  }
  
}

extension Dimension: CustomDebugStringConvertible {
  var debugDescription: String {
    switch self {
    case .auto:
      return "auto"
    case .fixed(let value):
      return String(format: "%.0fpt", value)
    case .proportional(let fraction):
      return String(format: "%.0f%%", fraction * 100.0)
    }
  }
}

