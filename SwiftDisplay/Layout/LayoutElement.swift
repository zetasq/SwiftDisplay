//
//  LayoutElement.swift
//  SwiftDisplay
//
//  Created by Zhu Shengqi on 2018/4/7.
//  Copyright © 2018 Zhu Shengqi. All rights reserved.
//

import Foundation

/** A constant that indicates that the parent's size is not yet determined in a given dimension. */
let LayoutElementParentDimensionUndefined = CGFloat.nan

/** A constant that indicates that the parent's size is not yet determined in either dimension. */
let LayoutElementParentSizeUndefined = CGSize(width: CGFloat.nan, height: CGFloat.nan)

enum LayoutElementType {
  case layoutSpec
  case displayNode
}

/**
 * The ASLayoutElement protocol declares a method for measuring the layout of an object. A layout
 * is defined by an ASLayout return value, and must specify 1) the size (but not position) of the
 * layoutElement object, and 2) the size and position of all of its immediate child objects. The tree
 * recursion is driven by parents requesting layouts from their children in order to determine their
 * size, followed by the parents setting the position of the children once the size is known
 *
 * The protocol also implements a "family" of LayoutElement protocols. These protocols contain layout
 * options that can be used for specific layout specs. For example, ASStackLayoutSpec has options
 * defining how a layoutElement should shrink or grow based upon available space.
 *
 * These layout options are all stored in an ASLayoutOptions class (that is defined in ASLayoutElementPrivate).
 * Generally you needn't worry about the layout options class, as the layoutElement protocols allow all direct
 * access to the options via convenience properties. If you are creating custom layout spec, then you can
 * extend the backing layout options class to accommodate any new layout options.
 */
protocol LayoutElement: AnyObject & LayoutElementExtensibility & LayoutElementAsciiArtProtocol { // TODO: add TraitEnvironment conformance
  
  /**
   * @abstract Returns type of layoutElement
   */
  var layoutElementType: LayoutElementType { get }
  
  /**
   * @abstract A size constraint that should apply to this ASLayoutElement.
   */
  var style: LayoutElementStyle { get }
  
  /**
   * @abstract Returns all children of an object which class conforms to the ASLayoutElement protocol
   */
  var sublayoutElements: [LayoutElement] { get }
}


final class LayoutElementStyle {
  
}
