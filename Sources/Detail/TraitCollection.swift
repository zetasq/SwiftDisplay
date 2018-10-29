//
//  TraitCollection.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 9/4/2018.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation
import UIKit

/**
 * @abstract This is an internal struct-representation of ASTraitCollection.
 *
 * @discussion This struct is for internal use only. Framework users should always use ASTraitCollection.
 *
 * If you use ASPrimitiveTraitCollection, please do make sure to initialize it with ASPrimitiveTraitCollectionMakeDefault()
 * or ASPrimitiveTraitCollectionFromUITraitCollection(UITraitCollection*).
 */
struct PrimitiveTraitCollection: Equatable {
  
  /**
   * Creates ASPrimitiveTraitCollection with default values.
   */
  static let `default` = PrimitiveTraitCollection(
    horizontalSizeClass: .unspecified,
    verticalSizeClass: .unspecified,
    displayScale: 0,
    displayGamut: .unspecified,
    userInterfaceIdiom: .unspecified,
    forceTouchCapability: .unknown, 
    layoutDirection: .unspecified,
    preferredContentSizeCategory: .unspecified,
    containerSize: .zero
  )
  
  var horizontalSizeClass: UIUserInterfaceSizeClass
  var verticalSizeClass: UIUserInterfaceSizeClass
  
  var displayScale: CGFloat
  var displayGamut: UIDisplayGamut
  
  var userInterfaceIdiom: UIUserInterfaceIdiom
  var forceTouchCapability: UIForceTouchCapability
  var layoutDirection: UITraitEnvironmentLayoutDirection
  
  var preferredContentSizeCategory: UIContentSizeCategory
  
  var containerSize: CGSize
  
  init(horizontalSizeClass: UIUserInterfaceSizeClass,
       verticalSizeClass: UIUserInterfaceSizeClass,
       displayScale: CGFloat,
       displayGamut: UIDisplayGamut,
       userInterfaceIdiom: UIUserInterfaceIdiom,
       forceTouchCapability: UIForceTouchCapability,
       layoutDirection: UITraitEnvironmentLayoutDirection,
       preferredContentSizeCategory: UIContentSizeCategory,
       containerSize: CGSize
    ) {
    self.horizontalSizeClass = horizontalSizeClass
    self.verticalSizeClass = verticalSizeClass
    self.displayScale = displayScale
    self.displayGamut = displayGamut
    self.userInterfaceIdiom = userInterfaceIdiom
    self.forceTouchCapability = forceTouchCapability
    self.layoutDirection = layoutDirection
    self.preferredContentSizeCategory = preferredContentSizeCategory
    self.containerSize = containerSize
  }
  
  /**
   * Creates a ASPrimitiveTraitCollection from a given UITraitCollection.
   */
  init(uiTraitCollection: UITraitCollection) {
    self.init(
      horizontalSizeClass: uiTraitCollection.horizontalSizeClass,
      verticalSizeClass: uiTraitCollection.verticalSizeClass,
      displayScale: uiTraitCollection.displayScale, 
      displayGamut: uiTraitCollection.displayGamut,
      userInterfaceIdiom: uiTraitCollection.userInterfaceIdiom,
      forceTouchCapability: uiTraitCollection.forceTouchCapability,
      layoutDirection: uiTraitCollection.layoutDirection,
      preferredContentSizeCategory: uiTraitCollection.preferredContentSizeCategory,
      containerSize: .zero
    )
    
    // preferredContentSizeCategory is also available on older iOS versions, but only via UIApplication class.
    // It should be noted that [UIApplication sharedApplication] is unavailable because Texture is built with only extension-safe API.
  }
  
}

/**
 * Abstraction on top of UITraitCollection for propagation within AsyncDisplayKit-Layout
 */
protocol TraitEnvironment: AnyObject {
  
  
  /**
   * **getter**:
   * @abstract Returns a struct-representation of the environment's ASEnvironmentDisplayTraits.
   *
   * @discussion This only exists as an internal convenience method. Users should access the trait collections through
   * the NSObject based asyncTraitCollection API
   */
  /**
   * **setter**:
   * @abstract Sets a trait collection on this environment state.
   *
   * @discussion This only exists as an internal convenience method. Users should not override trait collection using it.
   * Use [ASViewController overrideDisplayTraitsWithTraitCollection] block instead.
   */
  var primitiveTraitCollection: PrimitiveTraitCollection { get set }
  
  /**
   * @abstract Returns the thread-safe UITraitCollection equivalent.
   */
  var asyncTraitCollection: TraitCollection { get }
  
}

// TODO: replace Texture's macros

final class TraitCollection {
  let horizontalSizeClass: UIUserInterfaceSizeClass
  let verticalSizeClass: UIUserInterfaceSizeClass
  
  let displayScale: CGFloat
  let displayGamut: UIDisplayGamut
  
  let userInterfaceIdiom: UIUserInterfaceIdiom
  let forceTouchCapability: UIForceTouchCapability
  let layoutDirection: UITraitEnvironmentLayoutDirection
  
  let preferredContentSizeCategory: UIContentSizeCategory
  
  let containerSize: CGSize
  
  init(horizontalSizeClass: UIUserInterfaceSizeClass,
       verticalSizeClass: UIUserInterfaceSizeClass,
       displayScale: CGFloat,
       displayGamut: UIDisplayGamut,
       userInterfaceIdiom: UIUserInterfaceIdiom,
       forceTouchCapability: UIForceTouchCapability,
       layoutDirection: UITraitEnvironmentLayoutDirection,
       preferredContentSizeCategory: UIContentSizeCategory,
       containerSize: CGSize
    ) {
    self.horizontalSizeClass = horizontalSizeClass
    self.verticalSizeClass = verticalSizeClass
    self.displayScale = displayScale
    self.displayGamut = displayGamut
    self.userInterfaceIdiom = userInterfaceIdiom
    self.forceTouchCapability = forceTouchCapability
    self.layoutDirection = layoutDirection
    self.preferredContentSizeCategory = preferredContentSizeCategory
    self.containerSize = containerSize
  }

  convenience init(uiTraitCollection: UITraitCollection, containerSize: CGSize) {
    self.init(
      horizontalSizeClass: uiTraitCollection.horizontalSizeClass,
      verticalSizeClass: uiTraitCollection.verticalSizeClass,
      displayScale: uiTraitCollection.displayScale, 
      displayGamut: uiTraitCollection.displayGamut,
      userInterfaceIdiom: uiTraitCollection.userInterfaceIdiom,
      forceTouchCapability: uiTraitCollection.forceTouchCapability,
      layoutDirection: uiTraitCollection.layoutDirection,
      preferredContentSizeCategory: uiTraitCollection.preferredContentSizeCategory,
      containerSize: containerSize
    )
  }
  

  
}

extension TraitCollection: Equatable {
  
  static func == (lhs: TraitCollection, rhs: TraitCollection) -> Bool {
    return lhs.horizontalSizeClass == rhs.horizontalSizeClass
    && lhs.verticalSizeClass == rhs.verticalSizeClass
    && lhs.displayScale == rhs.displayScale
    && lhs.displayGamut == rhs.displayGamut
    && lhs.userInterfaceIdiom == rhs.userInterfaceIdiom
    && lhs.forceTouchCapability == rhs.forceTouchCapability
    && lhs.layoutDirection == rhs.layoutDirection
    && lhs.preferredContentSizeCategory == rhs.preferredContentSizeCategory
    && lhs.containerSize == rhs.containerSize
  }
  
}

/**
 * These are internal helper methods. Should never be called by the framework users.
 */
extension TraitCollection {
  convenience init(primitiveTraitCollection: PrimitiveTraitCollection) {
    self.init(horizontalSizeClass: primitiveTraitCollection.horizontalSizeClass,
              verticalSizeClass: primitiveTraitCollection.verticalSizeClass,
              displayScale: primitiveTraitCollection.displayScale,
              displayGamut: primitiveTraitCollection.displayGamut,
              userInterfaceIdiom: primitiveTraitCollection.userInterfaceIdiom,
              forceTouchCapability: primitiveTraitCollection.forceTouchCapability,
              layoutDirection: primitiveTraitCollection.layoutDirection,
              preferredContentSizeCategory: primitiveTraitCollection.preferredContentSizeCategory,
              containerSize: primitiveTraitCollection.containerSize
    )
  }
  
  var primitiveTraitCollection: PrimitiveTraitCollection {
    return PrimitiveTraitCollection(
      horizontalSizeClass: self.horizontalSizeClass,
      verticalSizeClass: self.verticalSizeClass,
      displayScale: self.displayScale,
      displayGamut: self.displayGamut,
      userInterfaceIdiom: self.userInterfaceIdiom,
      forceTouchCapability: self.forceTouchCapability,
      layoutDirection: self.layoutDirection,
      preferredContentSizeCategory: self.preferredContentSizeCategory,
      containerSize: self.containerSize
    )
  }
}
