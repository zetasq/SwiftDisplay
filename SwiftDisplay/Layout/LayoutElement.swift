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
protocol LayoutElement: LayoutElementExtensibility & TraitEnvironment & LayoutElementAsciiArtProtocol {
  
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
  
  /**
   * @abstract Asks the node to return a layout based on given size range.
   *
   * @param constrainedSize The minimum and maximum sizes the receiver should fit in.
   *
   * @return An ASLayout instance defining the layout of the receiver (and its children, if the box layout model is used).
   *
   * @discussion Though this method does not set the bounds of the view, it does have side effects--caching both the
   * constraint and the result.
   *
   * @warning Subclasses must not override this; it caches results from -calculateLayoutThatFits:.  Calling this method may
   * be expensive if result is not cached.
   *
   * @see [ASDisplayNode(Subclassing) calculateLayoutThatFits:]
   */
  func layoutThatFits(_ constrainedSize: SizeRange) -> Layout
  
  /**
   * Call this on children layoutElements to compute their layouts within your implementation of -calculateLayoutThatFits:.
   *
   * @warning You may not override this method. Override -calculateLayoutThatFits: instead.
   * @warning In almost all cases, prefer the use of ASCalculateLayout in ASLayout
   *
   * @param constrainedSize Specifies a minimum and maximum size. The receiver must choose a size that is in this range.
   * @param parentSize The parent node's size. If the parent component does not have a final size in a given dimension,
   *                  then it should be passed as ASLayoutElementParentDimensionUndefined (for example, if the parent's width
   *                  depends on the child's size).
   *
   * @discussion Though this method does not set the bounds of the view, it does have side effects--caching both the
   * constraint and the result.
   *
   * @return An ASLayout instance defining the layout of the receiver (and its children, if the box layout model is used).
   */
  func layoutThatFits(_ constrainedSize: SizeRange, parentSize: CGSize) -> Layout
  
  /**
   * Override this method to compute your layoutElement's layout.
   *
   * @discussion Why do you need to override -calculateLayoutThatFits: instead of -layoutThatFits:parentSize:?
   * The base implementation of -layoutThatFits:parentSize: does the following for you:
   * 1. First, it uses the parentSize parameter to resolve the nodes's size (the one assigned to the size property).
   * 2. Then, it intersects the resolved size with the constrainedSize parameter. If the two don't intersect,
   *    constrainedSize wins. This allows a component to always override its childrens' sizes when computing its layout.
   *    (The analogy for UIView: you might return a certain size from -sizeThatFits:, but a parent view can always override
   *    that size and set your frame to any size.)
   * 3. It caches it result for reuse
   *
   * @param constrainedSize A min and max size. This is computed as described in the description. The ASLayout you
   *                        return MUST have a size between these two sizes.
   */
  func calculateLayoutThatFits(_ constrainedSize: SizeRange) -> Layout
  
  /**
   * In certain advanced cases, you may want to override this method. Overriding this method allows you to receive the
   * layoutElement's size, parentSize, and constrained size. With these values you could calculate the final constrained size
   * and call -calculateLayoutThatFits: with the result.
   *
   * @warning Overriding this method should be done VERY rarely.
   */
  func calculateLayoutThatFits(_ constrainedSize: SizeRange, restrictedTo size: LayoutElementSize, relativeTo parentSize: CGSize) -> Layout
  
  var implementsLayoutMethod: Bool { get }
}

// LayoutElement default implementation
extension LayoutElement {
  
  func layoutThatFits(_ constrainedSize: SizeRange) -> Layout {
    return self.layoutThatFits(constrainedSize, parentSize: constrainedSize.maxSize)
  }
  
  func layoutThatFits(_ constrainedSize: SizeRange, parentSize: CGSize) -> Layout {
    return self.calculateLayoutThatFits(constrainedSize, restrictedTo: self.style.size, relativeTo: parentSize)
  }
  
  func calculateLayoutThatFits(_ constrainedSize: SizeRange, restrictedTo size: LayoutElementSize, relativeTo parentSize: CGSize) -> Layout {
    let resolvedRange = constrainedSize.intersect(self.style.size.resolve(withParentSize: parentSize))
    return self.calculateLayoutThatFits(resolvedRange)
  }
  
}

extension LayoutElement {
  
  /**
   * This function will walk the layout element hierarchy and updates the layout element trait collection for every
   * layout element within the hierarchy.
   */
  func propagateDown(_ traitCollection: PrimitiveTraitCollection) {
    self.primitiveTraitCollection = traitCollection
    
    for subelement in self.sublayoutElements {
      subelement.propagateDown(traitCollection)
    }
  }
  
}

