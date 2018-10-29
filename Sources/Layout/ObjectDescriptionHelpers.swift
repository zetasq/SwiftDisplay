//
//  ObjectDescriptionHelpers.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 8/4/2018.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

protocol DebugNameProvider {
  
  /**
   * @abstract Name that is printed by ascii art string and displayed in description.
   */
  var debugName: String { get }
  
}

/**
 * Your base class should conform to this and override `-debugDescription`
 * to call `[self propertiesForDebugDescription]` and use `ASObjectDescriptionMake`
 * to return a string. Subclasses of this base class just need to override
 * `propertiesForDebugDescription`, call super, and modify the result as needed.
 */
protocol DebugDescriptionProvider {
  
  var propertiesForDebugDescription: [[String: Any]] { get }
  
}

/**
 * Your base class should conform to this and override `-description`
 * to call `[self propertiesForDescription]` and use `ASObjectDescriptionMake`
 * to return a string. Subclasses of this base class just need to override 
 * `propertiesForDescription`, call super, and modify the result as needed.
 */
protocol DescriptionProvider {
  
  var propertiesForDescription: [[String: Any]] { get }
  
}
